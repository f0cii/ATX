import time
from os.env import getenv
from testing import assert_equal, assert_true, assert_false
from python import Python
from python import PythonObject
from sha import sha256_encode
from testing import assert_equal
from time import now
from collections.vector import InlinedFixedVector
from atxs_classic import *
from atxs_classic.orderbook import Orderbook
from atxs_classic.httpclient import HttpClient, Headers, VERB_GET
from atxs_classic.websocket import (
    WebSocket,
    set_on_connected,
    set_on_before_reconnect,
    set_on_heartbeat,
    set_on_message,
)
from bitmex.bitmex_client import tset_bitmex_api
from gateio.futures_client import GateIOFuturesClient

from collections import Dict
from atxs import now_ms, now_ns
from sonic import *


fn test_sonic() raises:
    var doc = JsonObject()
    var v = "12345"
    doc.insert_str("a", v)
    var s = doc.to_string()
    assert_equal(s, '{"a":"12345"}')
    # _ = doc^


fn test_httpclient() raises:
    # var base_url = "https://www.baidu.com"
    var base_url = "https://api.bybit.com"
    # https://api.bybit.com/v3/public/time
    var client = HttpClient(base_url)
    var headers = Headers()
    headers["a"] = "abc"
    var response = client.get("/v3/public/time", headers)
    logi(response.text)
    # _ = client.do_request("/v3/public/time", VERB_GET, headers, "", 1024 * 1024)
    # _ = client.do_request("/v3/public/time", VERB_GET, headers, "", 1024 * 1024)


fn test_websocket() raises:
    # https://socketsbay.com/test-websockets
    # var base_url = "wss://socketsbay.com/wss/v2/1/demo/"

    # var host = "socketsbay.com"
    # var port = "443"
    # var path = "/wss/v2/1/demo/"

    # wss://echo.websocket.org
    # var host = "echo.websocket.org"
    # var port = "443"
    # var path = "/"

    # logd("test_websocket")

    var testnet = False
    var private = False
    var category = "linear"
    var host = "stream-testnet.bybit.com" if testnet else "stream.bybit.com"
    var port = "443"
    var path = "/v5/private" if private else "/v5/public/" + category

    # wss://echo.websocket.org
    # var host = "echo.websocket.org"
    # var port = "443"
    # var path = "/"
    var ws = WebSocket(host=host, port=port, path=path)
    var id = ws.get_id()
    var on_connected = ws.get_on_connected()
    var on_before_reconnect = ws.get_on_before_reconnect()
    var on_heartbeat = ws.get_on_heartbeat()
    var on_message = ws.get_on_message()

    set_on_connected(id, on_connected^)
    set_on_before_reconnect(id, on_before_reconnect^)
    set_on_heartbeat(id, on_heartbeat^)
    set_on_message(id, on_message^)
    ws.connect()
    logi("connect done")

    var ioc = seq_asio_ioc()
    seq_asio_run(ioc)

    print("OK")

    # run_forever()
    _ = ws^


fn to_hex_string(digest: InlinedFixedVector[UInt8, 32]) -> String:
    var lookup = String("0123456789abcdef")
    var result: String = ""
    for i in range(len(digest)):
        var v = int(digest[i])
        result += lookup[(v >> 4)]
        result += lookup[v & 15]

    return result


fn test_sha256() raises:
    var text = "hello world"
    print(text)
    var hex_string = to_hex_string(
        sha256_encode(text.unsafe_ptr().bitcast[DType.uint8](), len(text))
    )
    print(hex_string)
    assert_equal(
        hex_string,
        "b94d27b9934d3e08a52e52d7da7dabfac484efe37a5380ee9088f7ace2efcde9",
    )


fn test_sha512() raises:
    # alias SHA512_DIGEST_LENGTH	=	64

    var text = "hello world"
    var s = sha512_hex(text)
    # var result = UnsafePointer[c_void](SHA512_DIGEST_LENGTH)
    # seq_sha512(
    # message: UnsafePointer[c_char],
    # message_len: c_size_t,
    # result: c_void_ptr,

    # var b_ptr = UnsafePointer[UInt8].alloc(SHA512_DIGEST_LENGTH)
    # var n = seq_sha512(
    #     text.unsafe_cstr_ptr(),
    #     len(text),
    #     b_ptr,
    # )
    # var s_ptr = UnsafePointer[UInt8].alloc(65)
    # var s_len = seq_hex_encode(b_ptr, n, s_ptr)
    # # var s = c_str_to_string(s_ptr, s_len)
    # var s = String(s_ptr, s_len + 1)

    # b_ptr.free()

    print(s)


fn tset_gateio_client() raises:
    # var api_key = ""
    # var api_secret = ""
    # testnet
    var api_key = "10d23703c09150b1bf4c5bb7f0f1dd2e"
    var api_secret = "996c14c32700f3ce63d0f5530793766a7b8bda8cdfaf5d71071915235f3d3f50"
    # var base_url = "https://api.gateio.ws/api/v4"
    # var base_url = "https://api.gateio.ws"
    var base_url = "https://fx-api-testnet.gateio.ws"
    var ex = GateIOFuturesClient(api_key, api_secret, base_url)
    var settle = "usdt"
    # {"contract":symbol,"size":size,"price": price,"tif": tif,"close": close,"auto_size":auto_size,"reduce_only":reduce_only}
    var contract = "BTC_USDT"
    var size = 1
    var price = "60000.0"
    var tif = ""
    var close = False
    var auto_size = ""
    var reduce_only = False

    # var res = ex.get_contracts(settle, limit=1)
    # logi(res)

    var res0 = ex.get_contract(settle, "BTC_USDT")
    logi(res0)

    print("100")
    var r = ex._sign("Hello")
    print("101")
    logi("r=" + r)

    # BTC_USDT "quanto_multiplier": "0.0001"

    # var res1 = ex.place_order(
    #     settle,
    #     contract=contract,
    #     size=size,
    #     price=price,
    #     close=close,
    #     reduce_only=reduce_only,
    #     tif=tif,
    #     auto_size=auto_size,
    # )
    # logi(res1)

    var res2 = ex.get_futures_orders(
        settle=settle,
        status="open",
        # contract: Optional[String] = None,
        # limit: Optional[Int] = None,
        # offset: Optional[Int] = None,
        # last_id: Optional[String] = None,
    )
    logi(res2)


fn test_json() raises:
    var json = Python.import_module("json")
    var start = now_ns()
    # var data_param = json.loads("{}")
    var data_param = Python.dict()
    data_param["time"] = 1000
    # data_param = {
    #         "time": data_time,
    #         "channel": self.channel,
    #         "event": "api",
    #         "payload": {
    #             "req_header": {"X-Gate-Channel-Id": self.header},
    #             "api_key": self.cfg.api_key,
    #             "timestamp": f"{data_time}",
    #             "signature": hmac.new(
    #                 self.cfg.api_secret.encode("utf8"),
    #                 message.encode("utf8"),
    #                 hashlib.sha512,
    #             ).hexdigest(),
    #             "req_id": self.req_id,
    #             "req_param": self.payload,
    #         },
    #     }
    # data_param["payload"] = json.loads("{}")
    var payload = Python.dict()
    payload["api_key"] = "ahe"
    data_param["payload"] = payload  # Python.dict()
    # data_param["payload"]["api_key"] = "ahe"
    var s = str(json.dumps(data_param))
    var end = now_ns()
    var elapsed = end - start
    print(String.write("Elapsed time: ", elapsed, " ns"))
    print(s)


fn test_json2() raises:
    var start = now_ns()
    for i in range(100):
        var data_param = JsonObject()

        data_param.insert_i64("time", 100)
        data_param.insert_str("channel", "abc")
        data_param.insert_str("event", "api")
        data_param.insert_str("event1", "hello")
        data_param.insert_str("event2", "hello")
        data_param.insert_i64("a", 100)
        data_param.insert_f64("f", 100.0)
        data_param.insert_bool("b", True)
        var payload = JsonObject()
        var req_header = JsonObject()
        req_header.insert_str("X-Gate-Channel-Id", "self.header")
        var signature = ""  # hmac_sha512_hex(message, self.cfg.api_secret)
        payload.insert_object("req_header", req_header)
        payload.insert_str("api_key", "self.cfg.api_key")
        payload.insert_str("timestamp", "str(data_time)")
        payload.insert_str("signature", signature)
        payload.insert_str("req_id", "self.req_id")
        payload.insert_str("req_param", "self.payload")
        data_param.insert_object("payload", payload)

        var s = data_param.to_string()
        _ = req_header^
        _ = payload^
    var end = now_ns()
    var elapsed = end - start
    print(String.write("Elapsed time: ", elapsed, " ns"))
    # print(s)


fn test_json3() raises:
    var orjson = Python.import_module("orjson")
    try:
        # var json = Python.import_module("json")
        var start = now_ns()
        # var data_param = orjson.loads("{}")
        # var data_param = Python.dict()
        for i in range(100):
            var data_param = PythonObject(Dict[PythonObject, PythonObject]())
            # data_param["time"] = 1000
            data_param["time"] = 100
            data_param["channel"] = "abc"
            data_param["event"] = "api"
            data_param["event1"] = "hello"
            data_param["event2"] = "hello"
            data_param["a"] = 100
            data_param["f"] = 100.0
            data_param["b"] = True
            var payload = PythonObject(Dict[PythonObject, PythonObject]())
            var req_header = PythonObject(Dict[PythonObject, PythonObject]())
            req_header["X-Gate-Channel-Id"] = "self.header"
            var signature = ""  # hmac_sha512_hex(message, self.cfg.api_secret)
            payload["req_header"] = req_header
            payload["api_key"] = "self.cfg.api_key"
            payload["timestamp"] = "str(data_time)"
            payload["signature"] = signature
            payload["req_id"] = "self.req_id"
            payload["req_param"] = "self.payload"
            data_param["payload"] = payload

            var s = str(orjson.dumps(data_param))
        var end = now_ns()
        var elapsed = end - start
        print(String.write("Elapsed time: ", elapsed, " ns"))
        # print(s)

        # var yy_doc = yyjson_mut_doc()
        # yy_doc.add_str("req_id", "100")
        # yy_doc.add_str("op", "subscribe")
        # # var values = List[String]()
        # # var topics = "a,b,c".split(",")
        # # for topic in topics:
        # #     values.append(topic[])
        # # yy_doc.arr_with_str("args", values)
        # var body_str = yy_doc.mut_write()
        # print(body_str)
        # _ = values ^
    except e:
        print(e)


# fn test_ember_json() raises:
#     var start = now()
#     var n = 1000000
#     for i in range(n):
#         # parse string
#         var data_param = Object()
#         data_param["time"] = 100
#         data_param["channel"] = "abc"
#         data_param["event"] = "api"
#         data_param["a"] = 100
#         data_param["f"] = 100.0
#         data_param["b"] = True
#         var payload = Object()
#         var req_header = Object()
#         req_header["X-Gate-Channel-Id"] = "self.header"
#         var signature = ""  # hmac_sha512_hex(message, self.cfg.api_secret)
#         payload["req_header"] = req_header
#         payload["api_key"] = "self.cfg.api_key"
#         payload["timestamp"] = "str(data_time)"
#         payload["signature"] = signature
#         payload["req_id"] = "self.req_id"
#         payload["req_param"] = "self.payload"
#         data_param["payload"] = payload

#         var s = str(data_param)
#         # print("ember_json: ", s)
#     var end = now()
#     print("ember_json Time: ", (end - start) / n, "ns")


fn test_sonic_json() raises:
    var start = now()
    var n = 1000000
    for i in range(n):
        # parse string
        var data_param = JsonObject()
        data_param.insert_i64("time", 100)
        data_param.insert_str("channel", "abc")
        data_param.insert_str("event", "api")
        data_param.insert_i64("a", 100)
        data_param.insert_f64("f", 100.0)
        data_param.insert_bool("b", True)
        var payload = JsonObject()
        var req_header = JsonObject()
        req_header.insert_str("X-Gate-Channel-Id", "self.header")
        var signature = ""  # hmac_sha512_hex(message, self.cfg.api_secret)
        payload.insert_object("req_header", req_header)
        payload.insert_str("api_key", "self.cfg.api_key")
        payload.insert_str("timestamp", "str(data_time)")
        payload.insert_str("signature", signature)
        payload.insert_str("req_id", "self.req_id")
        payload.insert_str("req_param", "self.payload")
        data_param.insert_object("payload", payload)

        var s = data_param.to_string()
        # print("sonic_json: ", s)
    var end = now()
    print("sonic_json Time: ", (end - start) / n, "ns")


fn main() raises:
    var pre_init_lib = getenv("MOJO_PYTHON_LIBRARY")
    if pre_init_lib:
        print("\npython_lib:", pre_init_lib, end="\n\n")
    sys = Python.import_module("sys")
    print("----module-paths----")
    for p in sys.path:
        print(p)
    print("\npython_lib:", getenv("MOJO_PYTHON_LIBRARY"))
    print("python_exe:", getenv("PYTHONEXECUTABLE"))

    print("0")
    # var ctypes = Python.import_module("ctypes")
    print("1")
    # ctypes.cdll.LoadLibrary("./libecho.so")
    print("2")
    # for i in range(100000000):
    init_log("DBG", "")
    logd("debug")
    logi("info")
    logw("warn")
    loge("error")

    var s = SSMap()
    var f = Fixed("100.123")
    logi(str(f))

    test_sonic()
    # test_httpclient()
    # test_websocket()

    var ob = Orderbook("BNBUSDT")

    # var a = hmac_sha256_hex("abc", "abc")
    # print(a)

    # test_sha256()
    # test_sha512()
    # tset_bitmex_api()
    # tset_gateio_client()
    # var s = sprintf("A: %s", "Hello")

    # test_json()
    # test_json2()
    # test_json3()
    # test_json_type_to_string()
    
    # test_ember_json()
    # test_sonic_json()

    var v = JsonObject("{}")
    _ = v^

    time.sleep(1)

    # 不通过
    # LD_LIBRARY_PATH=.:$LD_LIBRARY_PATH ./echo-demo
    # 通过,请使用这个方法
    # https://docs.modular.com/max/roadmap#error-cannot-allocate-memory-in-static-tls-block
    # export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(realpath .)
    # export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(realpath . .magic/envs/default/lib)
    # export LD_PRELOAD=./libecho.so
    # LD_PRELOAD=./libecho.so ./echo-demo

    # export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(realpath .magic/envs/default/lib .magic/envs/default/lib/python3.12/site-packages/)
    # LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(realpath .) LD_PRELOAD=./libecho.so ./echo-demo
