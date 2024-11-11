import sys
import time
from testing import assert_equal

from atxs_classic import *
from gateio_ws import Configuration, Connection, WebSocketResponse, BaseChannel

from sonic import *


fn test_to_float() raises:
    var s = "123.456"
    var d = float(s)
    assert_equal(d, 123.456)


fn t1est_ws_orderbook() raises:
    var conn = Connection(Configuration())
    var demo_cp = "BTC_USDT"
    # var order_book = LocalOrderBook(demo_cp)
    var channel = BaseChannel(
        "spot.order_book_update", conn
    )  # , order_book.ws_callback)

    var ioc = seq_asio_ioc()
    seq_asio_run_ex(ioc, -1, False)

    conn.connect()

    # 要等待连接完毕
    time.sleep(3)

    var p = JsonValue("[]")
    var pv = JsonValueArrayView(p)
    pv.push_str(demo_cp)
    pv.push_str("100ms")

    print("p", str(p))
    # channel.subscribe([demo_cp, "100ms"])
    channel.subscribe(p^)

    time.sleep(50000)
    _ = conn^


fn t1st_ws_order() raises:
    # var app = "spot"
    var app = "futures"
    var settle = "usdt"
    var test_net = False
    var api_key = "10d23703c09150b1bf4c5bb7f0f1dd2e"
    var api_secret = "996c14c32700f3ce63d0f5530793766a7b8bda8cdfaf5d71071915235f3d3f50"
    var conn = Connection(
        Configuration(
            app=app,
            settle=settle,
            test_net=test_net,
            api_key=api_key,
            api_secret=api_secret,
        )
    )
    var demo_cp = "BTC_USDT"
    # var order_book = LocalOrderBook(demo_cp)
    var channel = BaseChannel(
        "spot.order_book_update", conn
    )  # , order_book.ws_callback)

    # 登录成功返回
    # {"header":{"response_time":"1729479533423","status":"200","channel":"futures.login","event":"api","client_id":"223.112.219.22-0xc24eeaf900"},"data":{"result":{"uid":"16792411","api_key":"10d23703c09150b1bf4c5bb7f0f1dd2e"}},"request_id":"req_id"}

    var ioc = seq_asio_ioc()
    seq_asio_run_ex(ioc, -1, False)

    conn.connect()

    # 要等待连接完毕
    time.sleep(3)

    # var p = JSON(is_array=True)
    # # var a = p.array()
    # p.array().append(demo_cp)
    # p.array().append("100ms")
    # print("p", str(p))
    # # channel.subscribe([demo_cp, "100ms"])
    # channel.subscribe(p)

    channel.login("header", "req_id")

    time.sleep(3)

    # 下单
    # var order_place_param = Dict[String, object]{
    #     "text": "t-sssd",
    #     "currency_pair": "BCH_USDT",
    #     "type": "limit",
    #     "account": "spot",
    #     "side": "buy",
    #     "iceberg": "0",
    #     "price": "20",
    #     "amount": "0.05",
    #     "time_in_force": "gtc",
    #     "auto_borrow": False,
    # }
    var order_place_param = JsonValue()
    # var a = Pointer.address_of(order_place_param.object())
    # order_place_param.object()[""] = 1
    # a[]["a"] = 1
    var obj_view = JsonValueObjectView(order_place_param)
    obj_view.insert_i64("a", 1)
    channel.api_request(order_place_param^, "header", "001")

    time.sleep(50000)
    _ = conn^


fn test_ct_init() raises:
    _ = seq_ct_init()
    _ = seq_photon_init_default()
