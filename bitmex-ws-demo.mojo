import sys
from time import sleep
from atxs import now_ms, now_ns
from atxs_classic import *
from atxs_classic.websocket import *
from bitmex.api_key import generate_nonce, generate_signature
from bitmex.subscriptions import NO_SYMBOL_SUBS, DEFAULT_SUBS
from bitmex.bitmex_websocket import BitMEXWebsocket


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

    # var stop_flag = False
    var ioc = seq_asio_ioc()
    # while not stop_flag:
    #     # logi("task 0 loop")
    #     seq_asio_ioc_poll(ioc)
    #     # logi("task 0 loop end")
    #     # sleep(0.001)
    #     sleep(0.001)
    seq_asio_run(ioc)

    print("OK")

    # run_forever()
    _ = ws^


fn test_bitmex_ws() raises:
    var ws = BitMEXWebsocket(
        endpoint="wss://ws.testnet.bitmex.com/realtime",
        symbol="BNBUSDT",
        api_key=None,
        api_secret=None,
    )

    # logger.info("Instrument data: %s" % ws.get_instrument())

    # Run forever
    # while ws.ws.connected():
    #     # logger.info("Ticker: %s" % ws.get_ticker())
    #     # if ws.api_key:
    #     #     # logger.info("Funds: %s" % ws.funds())
    #     #     pass
    #     # logger.info("Market Depth: %s" % ws.market_depth())
    #     # logger.info("Recent Trades: %s\n\n" % ws.recent_trades())
    #     sleep(10)

    # var stop_flag = False
    var ioc = seq_asio_ioc()
    # while not stop_flag:
    #     # logi("task 0 loop")
    #     seq_asio_ioc_poll(ioc)
    #     # logi("task 0 loop end")
    #     # sleep(0.001)
    #     sleep(0.001)

    seq_asio_run(ioc)

    _ = ws^


fn test_1() raises:
    # var py_time = Python.import_module("time")
    for i in range(len(NO_SYMBOL_SUBS)):
        # print(i)
        print(i, NO_SYMBOL_SUBS[i])

    var ms = now_ms()
    print(ms)


# fn signal_handler(signum: Int) -> None:
#     # logi("handle_exit: " + str(signum))
#     print("handle_exit")
#     sys.exit()


fn main() raises:
    _ = seq_ct_init()
    _ = seq_photon_init_default()
    # seq_init_photon_work_pool(1)
    var log_level = "DBG"
    var log_file = ""
    init_log(log_level, log_file)
    # logd("Hello DBG")

    # logi("Initialization return result: " + str(ret))

    # alias SIGINT = 2
    # seq_register_signal_handler(SIGINT, signal_handler)

    # var nonce = generate_nonce()
    # print(nonce)
    # secret: String, verb: String, url: String, nonce: Int, data: String
    # _ = _ECHO()

    # var verb = "POST"
    # var url = "/api/v1/order"
    # var nonce = 1416993995705
    # var data = """{"symbol":"XBTZ14","quantity":1,"price":395.01}"""
    # var secret = ""
    # var signature = generate_signature(secret, verb, url, nonce, data)
    # print(signature)

    # # var a = hmac_sha256_hex("abc", "abc")
    # # print(a)

    # var sign = Sign()
    # var b = sign.generate_signature(secret, verb, url, nonce, data)
    # print(b)

    # var start = now_ns()
    # for i in range(1000000):
    #     var b = sign.generate_signature(secret, verb, url, nonce, data)
    # var end = now_ns()
    # var elapsed_time = end - start
    # var average_time = elapsed_time / 1000000
    # logi("elapsed_time=" + str(elapsed_time) + "ns, average_time=" + str(average_time) + "ns")

    # var start1 = now_ns()
    # for i in range(1000000):
    #     var c = generate_signature(secret, verb, url, nonce, data)
    # var end1 = now_ns()
    # var elapsed_time1 = end1 - start1
    # var average_time1 = elapsed_time1 / 1000000
    # logi("elapsed_time=" + str(elapsed_time1) + "ns, average_time=" + str(average_time1) + "ns")

    # test_websocket()
    test_bitmex_ws()

    # LD_LIBRARY_PATH=.:$LD_LIBRARY_PATH ./bitmex_ws_test
    # 0313bef785c2ccc8dec07921f65760ce1e37e4abcd52895644ca72a986a96b8b
    # 0313bef785c2ccc8dec07921f65760ce1e37e4abcd52895644ca72a986a96b8b

    # export http_proxy="http://192.168.2.100:1080"
    # export https_proxy="http://192.168.2.100:1080"
