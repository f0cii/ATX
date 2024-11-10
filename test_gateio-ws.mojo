import sys
import time
from testing import assert_equal
from atxsys import *
from gateio_ws import (
    Configuration,
    Connection,
    WebSocketResponse,
    BaseChannel,
    ApiRequest,
)

from sonic import *


fn test_ws_order() raises:
    var app = "futures"
    var settle = "usdt"
    var test_net = True
    var api_key = "10d23703c09150b1bf4c5bb7f0f1dd2e"
    var api_secret = "996c14c32700f3ce63d0f5530793766a7b8bda8cdfaf5d71071915235f3d3f50"
    var cfg = Configuration(
        app=app,
        settle=settle,
        test_net=test_net,
        api_key=api_key,
        api_secret=api_secret,
    )
    var channel = "futures.login"
    var req_id = "req_id"
    var header = "header"
    var data_time = 1729491063
    var payload = JsonValue.from_str("{}")
    var text = ApiRequest(cfg, channel, header, req_id, payload).gen(data_time)

    assert_equal(
        text,
        """{"time":1729491063,"channel":"futures.login","event":"api","payload":{"req_header":{"X-Gate-Channel-Id":"header"},"api_key":"10d23703c09150b1bf4c5bb7f0f1dd2e","timestamp":"1729491063","signature":"7b1d78f5918c5f18091cd33973ff3e445fac05643c2c8528d8be3e7767577d6bc0c7f8992b31ffc440498c91d13d0a174332c610b8784218b39de507035be1eb","req_id":"req_id","req_param":{}}}""",
    )
