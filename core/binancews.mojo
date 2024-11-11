from memory import UnsafePointer
from atxs import now_ms, now_ns
from atxs_classic.websocket import (
    on_connected_callback,
    on_heartbeat_callback,
    on_message_callback,
    register_websocket,
    TLS1_3_VERSION,
    set_on_connected,
    set_on_heartbeat,
    set_on_message,
)
from .binanceclient import BinanceClient
from atxs_classic import *


struct BinanceWS:
    """
    Reference document: https://binance-docs.github.io/apidocs/futures/en/
    """

    var _ptr: c_void_ptr
    var _id: Int
    var _is_private: Bool
    var _access_key: String
    var _secret_key: String
    var _topics_str: String
    var _heartbeat_time: UnsafePointer[Int64]
    var _client: BinanceClient

    fn __init__(
        inout self,
        is_private: Bool,
        testnet: Bool,
        access_key: String,
        secret_key: String,
        topics: String = "",
    ) raises:
        self._is_private = is_private
        self._access_key = access_key
        self._secret_key = secret_key
        self._topics_str = topics
        self._client = BinanceClient(testnet, access_key, secret_key)

        var host: String = "stream.binancefuture.com" if testnet else "fstream.binance.com"
        var port: String = "443"
        var path: String = ""

        if is_private:
            var listen_key = self._client.generate_listen_key()
            logi("listen_key=" + listen_key)
            path = "/ws/" + listen_key
        else:
            path = "/stream?streams=" + topics
        logd(
            "websocket wss://"
            + host
            + ":"
            + port
            + path
            + " isPrivate="
            + str(is_private)
        )

        var ptr = seq_websocket_new(
            host.unsafe_cstr_ptr(),
            port.unsafe_cstr_ptr(),
            path.unsafe_cstr_ptr(),
            TLS1_3_VERSION,
        )
        register_websocket(ptr)
        self._ptr = ptr
        self._id = seq_voidptr_to_int(ptr)
        self._heartbeat_time = UnsafePointer[Int64].alloc(1)
        self._heartbeat_time[0] = 0

    fn __del__(owned self):
        print("BinanceWS.__del__")

    fn get_id(self) -> Int:
        return self._id

    fn set_on_connected(self, owned callback: on_connected_callback):
        var id = self.get_id()
        set_on_connected(id, callback^)

    fn set_on_heartbeat(self, owned callback: on_heartbeat_callback):
        var id = self.get_id()
        set_on_heartbeat(id, callback^)

    fn set_on_message(self, owned callback: on_message_callback):
        var id = self.get_id()
        set_on_message(id, callback^)

    fn subscribe(self):
        logd("BinanceWS.subscribe")

    fn get_on_connected(self) -> on_connected_callback:
        fn wrapper():
            pass

        return wrapper

    fn get_on_heartbeat(self) -> on_heartbeat_callback:
        fn wrapper():
            pass

        return wrapper

    fn on_connected(self) -> None:
        logd("BinanceWS.on_connected")
        self._heartbeat_time[0] = now_ms()
        if self._is_private:
            pass
        else:
            self.subscribe()

    fn on_heartbeat(self) -> None:
        # logd("BinanceWS.on_heartbeat")
        var elapsed_time = now_ms() - self._heartbeat_time[0]
        if elapsed_time <= 1000 * 60 * 5:
            # logd("BinanceWS.on_heartbeat ignore [" + str(elapsed_time) + "]")
            return

        # For private subscriptions, listen_key renewal needs to be done within 60 minutes
        if self._is_private:
            try:
                var ret = self._client.extend_listen_key()
                logi("Renewal of listen_key returns: " + str(ret))
                self._heartbeat_time[0] = now_ms()
            except err:
                loge("Renewal of listen_key encountered an error: " + str(err))

    fn on_message(self, s: String) -> None:
        logd("BinanceWS::on_message: " + s)

        # {"e":"ORDER_TRADE_UPDATE","T":1704459987707,"E":1704459987709,"o":{"s":"BTCUSDT","c":"web_w4Sot5R1ym9ChzWfGdAm","S":"BUY","o":"LIMIT","f":"GTC","q":"0.010","p":"20000","ap":"0","sp":"0","x":"NEW","X":"NEW","i":238950797096,"l":"0","z":"0","L":"0","n":"0","N":"USDT","T":1704459987707,"t":0,"b":"200","a":"0","m":false,"R":false,"wt":"CONTRACT_PRICE","ot":"LIMIT","ps":"LONG","cp":false,"rp":"0","pP":false,"si":0,"ss":0,"V":"NONE","pm":"NONE","gtd":0}}
        # {"e":"ORDER_TRADE_UPDATE","T":1704460185744,"E":1704460185746,"o":{"s":"BTCUSDT","c":"web_w4Sot5R1ym9ChzWfGdAm","S":"BUY","o":"LIMIT","f":"GTC","q":"0.010","p":"20000","ap":"0","sp":"0","x":"CANCELED","X":"CANCELED","i":238950797096,"l":"0","z":"0","L":"0","n":"0","N":"USDT","T":1704460185744,"t":0,"b":"0","a":"0","m":false,"R":false,"wt":"CONTRACT_PRICE","ot":"LIMIT","ps":"LONG","cp":false,"rp":"0","pP":false,"si":0,"ss":0,"V":"NONE","pm":"NONE","gtd":0}}

        # var parser = OndemandParser(ParserBufferSize)
        # var doc = parser.parse(s)

        # _ = doc ^
        # _ = parser ^

    fn release(self) -> None:
        seq_websocket_delete(self._ptr)

    fn send(self, text: String) -> None:
        seq_websocket_send(self._ptr, text.unsafe_cstr_ptr(), len(text))

    fn connect(self):
        seq_websocket_connect(self._ptr)
