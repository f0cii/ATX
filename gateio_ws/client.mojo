import hashlib
import time

# from python import Python
from memory import UnsafePointer
from atxs_classic import *
from atxs import *
from collections import Dict
from atxs_classic.websocket import (
    register_websocket,
    TLS1_3_VERSION,
    on_connected_callback,
    on_before_reconnect_callback,
    on_heartbeat_callback,
    on_message_callback,
    set_on_connected,
    set_on_before_reconnect,
    set_on_heartbeat,
    set_on_message,
    WebSocket,
)
from sonic import *


alias WSCallback = fn (msg: String) raises -> None


struct GateWebsocketError:
    var code: Int
    var message: String

    fn __init__(out self, code: Int, message: String):
        self.code = code
        self.message = message

    fn __str__(self) -> String:
        return "code: " + str(self.code) + ", message: " + self.message


@value
struct Configuration:
    var app: String
    var settle: String
    # var test_net: Bool
    var host: String
    var port: Int
    var path: String
    var api_key: String
    var api_secret: String
    # event_loop=None,
    # executor_pool=None,
    # fnault_callback=None,
    var ping_interval: Int
    var max_retry: Int
    var verify: Bool

    fn __init__(
        inout self,
        app: String = "spot",
        settle: String = "usdt",
        test_net: Bool = False,
        # host: String = "",
        api_key: String = "",
        api_secret: String = "",
        # event_loop=None,
        # executor_pool=None,
        # fnault_callback=None,
        ping_interval: Int = 5,
        max_retry: Int = 10,
        verify: Bool = True,
    ):
        """Initialize running configuration

        @param app: Which websocket to connect to, spot or futures, fnault to spot
        @param settle: If app is futures, which settle currency to use, btc or usdt
        @param test_net: If app is futures, whether use test net
        @param host: Websocket host, inferred from app, settle and test_net if not provided
        @param api_key: APIv4 Key, must not be empty if subscribing to private channels
        @param api_secret: APIv4 Secret, must not be empty if subscribing to private channels
        @param event_loop: Event loop to use. fnault to asyncio fnault event loop
        @param executor_pool: Your callback executor pool. Default to asyncio fnault event loop if callback is
        awaitable, otherwise asyncio fnault concurrent.futures.Executor executor
        @param fnault_callback: Default callback function for all channels. If channels specific callback is not
        provided, it will be called instead
        @param ping_interval: Active ping interval to websocket server, fnault to 5 seconds
        @param max_retry: Connection retry times on connection to server lost. Reconnect will be given up if
        max_retry reached. No upper limit if negative. Default to 10.
        @param verify: enable certificate verification, fnault to True
        """
        self.app = app
        self.settle = settle
        self.api_key = api_key
        self.api_secret = api_secret
        # var fnault_host: String = "wss://api.gateio.ws/ws/v4/"
        # if app == "futures":
        #     fnault_host = "wss://fx-ws.gateio.ws/v4/ws/" + settle
        #     if test_net:
        #         fnault_host = "wss://fx-ws-testnet.gateio.ws/v4/ws/" + settle
        # self.host = host or fnault_host
        self.host = "api.gateio.ws"
        self.port = 443
        self.path = "/ws/v4/"
        if app == "futures":
            self.host = (
                "fx-ws.gateio.ws" if not test_net else "fx-ws-testnet.gateio.ws"
            )
            self.path = "/v4/ws/" + settle

        # self.loop = event_loop
        # self.pool = executor_pool
        # self.fnault_callback = fnault_callback
        self.ping_interval = ping_interval
        self.max_retry = max_retry
        self.verify = verify


struct WebSocketRequest:
    var cfg: Configuration
    var channel: String
    var event: String
    var payload: JsonValue
    var require_auth: Bool

    fn __init__(
        inout self,
        cfg: Configuration,
        channel: String,
        event: String,
        owned payload: JsonValue,
        require_auth: Bool,
    ):
        self.channel = channel
        self.event = event
        self.payload = payload ^
        self.require_auth = require_auth
        self.cfg = cfg

    fn __str__(self) raises -> String:
        var ts = int(now_ms() / 1000)
        var request = JsonObject()
        request.insert_i64("time", ts)
        request.insert_str("channel", self.channel)
        request.insert_str("event", self.event)
        if self.payload.is_array():
            request.insert_value("payload", self.payload)
        else:
            request.insert_value("payload", self.payload)
        if self.require_auth:
            if not (self.cfg.api_key and self.cfg.api_secret):
                raise Error("configuration does not provide api key or secret")
            var message = String.write(
                "channel=", self.channel, "&event=", self.event, "&time=", ts
            )
            var sign = hmac_sha512_hex(message, self.cfg.api_secret)
            var auth = JsonObject()
            auth.insert_str("method", "api_key")
            auth.insert_str("KEY", self.cfg.api_key)
            auth.insert_str("SIGN", sign)
            request.insert_object("auth", auth)
        var s = str(request)
        return s


struct ApiRequest:
    var cfg: Configuration
    var channel: String
    var header: String
    var req_id: String
    var payload: JsonValue

    fn __init__(
        inout self,
        cfg: Configuration,
        channel: String,
        header: String = "",
        req_id: String = "",
        owned payload: JsonValue = JsonValue(),
    ) raises:
        self.cfg = cfg
        if not (self.cfg.api_key != "" and self.cfg.api_secret != ""):
            raise Error("configuration does not provide api key or secret")
        self.channel = channel
        self.header = header
        self.req_id = req_id
        self.payload = payload ^

    fn gen(self, dt: Int = 0) raises -> String:
        # var orjson = Python.import_module("orjson")
        var data_time = dt if dt > 0 else int(now_ms() / 1000)
        # var data_time = int(now_ms() / 1000)
        # var param_json = json.dumps(self.payload)
        # var message = "%s\n%s\n%s\n%d" % ("api", self.channel, self.payload, data_time)
        var param_json = str(self.payload)
        var message = String.write(
            "api\n", self.channel, "\n", param_json, "\n", data_time
        )
        var signature = hmac_sha512_hex(message, self.cfg.api_secret)

        var data_param = JsonObject()
        var payload = JsonObject()
        var req_header = JsonObject()

        data_param.insert_i64("time", data_time)
        data_param.insert_str("channel", self.channel)
        data_param.insert_str("event", "api")

        req_header.insert_str("X-Gate-Channel-Id", self.header)

        payload.insert_object("req_header", req_header)
        payload.insert_str("api_key", self.cfg.api_key)
        payload.insert_str("timestamp", str(data_time))
        payload.insert_str("signature", signature)
        payload.insert_str("req_id", self.req_id)
        if self.payload.is_array():
            payload.insert_value("req_param", self.payload)
        else:
            payload.insert_value("req_param", self.payload)

        data_param.insert_object("payload", payload)

        # data_param = {
        #     "time": data_time,
        #     "channel": self.channel,
        #     "event": "api",
        #     "payload": {
        #         "req_header": {"X-Gate-Channel-Id": self.header},
        #         "api_key": self.cfg.api_key,
        #         "timestamp": str(data_time),
        #         "signature": hmac.new(
        #             self.cfg.api_secret.encode("utf8"),
        #             message.encode("utf8"),
        #             hashlib.sha512,
        #         ).hexdigest(),
        #         "req_id": self.req_id,
        #         "req_param": self.payload,
        #     },
        # }

        var s = str(data_param)
        return s


struct WebSocketResponse:
    var body: String

    fn __init__(out self, body: String):
        self.body = body

        # TODO: 1
        # msg = json.loads(body)
        # self.channel = msg.get("channel") or (msg.get("header") or {}).get(
        #     "channel"
        # )
        # if not self.channel:
        #     raise ValueError(
        #         "no channel found from response message: %s" % body
        #     )

        # self.timestamp = msg.get("time")
        # self.event = msg.get("event")
        # self.result = (
        #     msg.get("result")
        #     or (msg.get("data") or {}).get("result")
        #     or (msg.get("data") or {}).get("errs")
        # )
        # self.error = None
        # if msg.get("error"):
        #     self.error = GateWebsocketError(
        #         msg["error"].get("code"), msg["error"].get("message")
        #     )

    fn __str__(self) -> String:
        return self.body


struct Connection:
    var cfg: Configuration
    var channels: Dict[String, WSCallback]
    var ws: UnsafePointer[WebSocket]

    fn __init__(out self, cfg: Configuration):
        self.cfg = cfg
        self.channels = Dict[String, WSCallback]()
        self.ws = UnsafePointer[WebSocket].alloc(1)
        # self.sending_queue = asyncio.Queue()
        # self.sending_history = list()
        # self.event_loop: asyncio.AbstractEventLoop = (
        #     cfg.loop or asyncio.get_event_loop()
        # )
        # self.main_loop = None

    fn register(out self, channel: String, owned callback: WSCallback):
        self.channels[channel] = callback

    fn unregister(out self, channel: String):
        try:
            _ = self.channels.pop(channel)
        except:
            pass

    fn send(self, msg: String):
        self.ws[0].send(msg)

    # fn _active_ping(self) raises:  # , conn: websockets.WebSocketClientProtocol
    #     # TODO: 1
    #     while True:
    #         var data = Dict[String, Value]()
    #         data["time"] = Value(int(now_ms() / 1000))
    #         data["channel"] = String.write(self.cfg.app, ".ping")
    #         # data = json.dumps(
    #         #     {"time": int(time.time()), "channel": "%s.ping" % self.cfg.app}
    #         # )
    #         var data_value = Value(JsonDict(data))
    #         var data_str = any_json_type_to_string(data_value)
    #         # await conn.send(data_str)
    #         time.sleep(self.cfg.ping_interval)

    # fn _write(self):  # , conn: websockets.WebSocketClientProtocol
    #     # if self.sending_history:
    #     #     for msg in self.sending_history:
    #     #         if isinstance(msg, WebSocketRequest):
    #     #             msg = str(msg)
    #     #         await conn.send(msg)
    #     # while True:
    #     #     msg = await self.sending_queue.get()
    #     #     self.sending_history.append(msg)
    #     #     if isinstance(msg, WebSocketRequest):
    #     #         msg = str(msg)
    #     #     await conn.send(msg)
    #     pass

    # fn _read(self):  # , conn: websockets.WebSocketClientProtocol
    #     # TODO: 1
    #     # async for msg in conn:
    #     #     response = WebSocketResponse(msg)
    #     #     callback = self.channels.get(
    #     #         response.channel, self.cfg.fnault_callback
    #     #     )
    #     #     if callback is not None:
    #     #         if asyncio.iscoroutinefunction(callback):
    #     #             self.event_loop.create_task(callback(self, response))
    #     #         else:
    #     #             self.event_loop.run_in_executor(
    #     #                 self.cfg.pool, callback, self, response
    #     #             )
    #     pass

    fn close(self):
        pass

    fn connect(self) raises:
        var host = self.cfg.host
        var port = self.cfg.port
        var path = self.cfg.path
        print(String.write("host=", host, " port=", port, " path=", path))
        self.ws[0] = WebSocket(host=host, port=str(port), path=path)

        var id = self.ws[].get_id()
        print("id", id)

        var on_connect = self.get_on_connected()
        var on_heartbeat = self.get_on_heartbeat()
        var on_before_reconnect = self.get_on_before_reconnect()
        var on_message = self.get_on_message()

        set_on_connected(id, on_connect^)
        set_on_before_reconnect(id, on_before_reconnect^)
        set_on_heartbeat(id, on_heartbeat^)
        set_on_message(id, on_message^)

        print("100")

        self.ws[0].connect()
        print("101")

    fn get_on_connected(self) -> on_connected_callback:
        var self_ptr = UnsafePointer.address_of(self)

        fn wrapper():
            self_ptr[].__on_connected()

        return wrapper

    fn get_on_heartbeat(self) -> on_heartbeat_callback:
        var self_ptr = UnsafePointer.address_of(self)

        fn wrapper():
            self_ptr[].__on_heartbeat()

        return wrapper

    fn get_on_before_reconnect(self) -> on_before_reconnect_callback:
        var self_ptr = UnsafePointer.address_of(self)

        fn wrapper():
            self_ptr[].__on_before_reconnect()

        return wrapper

    fn get_on_message(self) -> on_message_callback:
        var self_ptr = UnsafePointer.address_of(self)

        fn wrapper(msg: String):
            self_ptr[].__on_message(msg)

        return wrapper

    fn __on_connected(self):
        logi("__on_connected")

    fn __on_before_reconnect(self) -> None:
        logi("__on_before_reconnect")

    fn __on_heartbeat(self):
        logi("__on_heartbeat")
        var request = JsonObject()
        request.insert_i64("time", int(now_ms() / 1000))
        request.insert_str("channel", String.write(self.cfg.app, ".ping"))
        var data_str = str(request)
        self.send(data_str)

    fn __on_message(self, message: String) -> None:
        """Handler for parsing WS messages."""
        logi("message: " + message)


struct BaseChannel:
    var name: String
    var require_auth: Bool
    var conn: UnsafePointer[Connection]
    var cfg: Configuration

    fn __init__(out self, name: String, conn: Connection):  # , callback=None
        self.name = name
        self.require_auth = False
        self.conn = UnsafePointer[Connection].address_of(conn)
        # self.callback = callback
        self.cfg = conn.cfg
        # self.conn.register(self.name, callback)

    fn subscribe(self, owned payload: JsonValue) raises:
        var request = WebSocketRequest(
            self.cfg, self.name, "subscribe", payload^, self.require_auth
        )
        var request_text = str(request)
        print("subscribe: ", request_text)
        self.conn[].send(request_text)

    fn unsubscribe(self, owned payload: JsonValue) raises:
        var request = WebSocketRequest(
            self.cfg, self.name, "unsubscribe", payload^, self.require_auth
        )
        self.conn[].send(str(request))

    fn api_request(
        self, owned payload: JsonValue, header: String = "", req_id: String = ""
    ) raises:
        # self.login(header, req_id)
        var data = ApiRequest(
            self.cfg, self.name, header, req_id, payload^
        ).gen()
        print("api_request", data)
        self.conn[].send(data)

    fn login(self, header: String, req_id: String) raises:
        var channel = "spot.login"
        if self.cfg.app != "spot":
            channel = "futures.login"
        var text = ApiRequest(
            self.cfg, channel, header, req_id, JsonValue.from_str("{}")
        ).gen()
        print("login", text)
        # {"header":{"response_time":"1729476264893","status":"401","channel":"spot.login","event":"api","client_id":"223.112.219.22-0xc361e14f20","conn_id":"0581594e4854392e","trace_id":"070ade61277aebdc15098034bcb8e2ee"},"data":{"errs":{"label":"INVALID_KEY","message":"Invalid key provided"}},"request_id":"0001"}
        self.conn[].send(text)
