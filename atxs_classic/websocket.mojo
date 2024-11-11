from memory import UnsafePointer
from sys.ffi import _get_global
from collections.dict import Dict
from utils.stringref import StringRef
from .ssmap import SSMap


alias TLS1_1_VERSION = 0x0302
alias TLS1_2_VERSION = 0x0303
alias TLS1_3_VERSION = 0x0304


alias on_connected_callback = fn () escaping -> None
alias on_before_reconnect_callback = fn () escaping -> None
alias on_heartbeat_callback = fn () escaping -> None
alias on_message_callback = fn (String) escaping -> None


alias OnConnectedCallbackHolder = Dict[Int, on_connected_callback]
alias BeforeReconnectCallbackHolder = Dict[Int, on_before_reconnect_callback]
alias OnHeartbeatCallbackHolder = Dict[Int, on_heartbeat_callback]
alias OnMessageCallbackHolder = Dict[Int, on_message_callback]


fn ws_on_connected_holder_ptr() -> UnsafePointer[OnConnectedCallbackHolder]:
    var ptr = _get_global[
        "__ws_on_connected_holder",
        _init_ws_on_connected_holder,
        _destroy_ws_on_connected_holder,
    ]()
    return ptr.bitcast[OnConnectedCallbackHolder]()


fn _init_ws_on_connected_holder(
    payload: UnsafePointer[NoneType],
) -> UnsafePointer[NoneType]:
    var ptr = UnsafePointer[OnConnectedCallbackHolder].alloc(1)
    ptr.init_pointee_move(OnConnectedCallbackHolder())
    return ptr.bitcast[NoneType]()


fn _destroy_ws_on_connected_holder(p: UnsafePointer[NoneType]):
    p.free()


fn ws_on_before_reconnect_holder_ptr() -> (
    UnsafePointer[BeforeReconnectCallbackHolder]
):
    var ptr = _get_global[
        "__ws_on_before_reconnect_holder",
        _init_ws_on_before_reconnect_holder,
        _destroy_ws_on_before_reconnect_holder,
    ]()
    return ptr.bitcast[BeforeReconnectCallbackHolder]()


fn _init_ws_on_before_reconnect_holder(
    payload: UnsafePointer[NoneType],
) -> UnsafePointer[NoneType]:
    var ptr = UnsafePointer[BeforeReconnectCallbackHolder].alloc(1)
    ptr.init_pointee_move(BeforeReconnectCallbackHolder())
    return ptr.bitcast[NoneType]()


fn _destroy_ws_on_before_reconnect_holder(p: UnsafePointer[NoneType]):
    p.free()


fn ws_on_heartbeat_holder_ptr() -> UnsafePointer[OnHeartbeatCallbackHolder]:
    var ptr = _get_global[
        "__ws_on_heartbeat_holder",
        _init_ws_on_heartbeat_holder,
        _destroy_ws_on_heartbeat_holder,
    ]()
    return ptr.bitcast[OnHeartbeatCallbackHolder]()


fn _init_ws_on_heartbeat_holder(
    payload: UnsafePointer[NoneType],
) -> UnsafePointer[NoneType]:
    var ptr = UnsafePointer[OnHeartbeatCallbackHolder].alloc(1)
    ptr.init_pointee_move(OnHeartbeatCallbackHolder())
    return ptr.bitcast[NoneType]()


fn _destroy_ws_on_heartbeat_holder(p: UnsafePointer[NoneType]):
    p.free()


fn ws_on_message_holder_ptr() -> UnsafePointer[OnMessageCallbackHolder]:
    var ptr = _get_global[
        "__moc", _init_ws_on_message_holder, _destroy_ws_on_message_holder
    ]()
    return ptr.bitcast[OnMessageCallbackHolder]()


fn _init_ws_on_message_holder(
    payload: UnsafePointer[NoneType],
) -> UnsafePointer[NoneType]:
    var ptr = UnsafePointer[OnMessageCallbackHolder].alloc(1)
    ptr.init_pointee_move(OnMessageCallbackHolder())
    return ptr.bitcast[NoneType]()


fn _destroy_ws_on_message_holder(p: UnsafePointer[NoneType]):
    p.free()


fn set_on_connected(id: Int, owned callback: on_connected_callback) -> None:
    # print("set_on_connected id=" + str(id))
    if id == 0:
        return
    ws_on_connected_holder_ptr()[][id] = callback^


fn set_on_before_reconnect(
    id: Int, owned callback: on_before_reconnect_callback
) -> None:
    # print("set_on_before_reconnect id=" + str(id))
    if id == 0:
        return
    ws_on_before_reconnect_holder_ptr()[][id] = callback^
    # print("set_on_before_reconnect done")


fn set_on_heartbeat(id: Int, owned callback: on_heartbeat_callback) -> None:
    if id == 0:
        return
    ws_on_heartbeat_holder_ptr()[][id] = callback^


fn set_on_message(id: Int, owned callback: on_message_callback) -> None:
    if id == 0:
        return
    ws_on_message_holder_ptr()[][id] = callback^


fn emit_on_connected(id: Int) -> None:
    # print("emit_on_connected id=" + str(id))
    try:
        ws_on_connected_holder_ptr()[][id]()
    except e:
        pass


fn emit_on_before_reconnect(id: Int) -> None:
    # print("emit_before_reconnect id=" + str(id))
    try:
        ws_on_before_reconnect_holder_ptr()[][id]()
        # print("emit_before_reconnect done")
    except e:
        pass


fn emit_on_heartbeat(id: Int) -> None:
    try:
        ws_on_heartbeat_holder_ptr()[][id]()
    except e:
        pass


fn emit_on_message(id: Int, data: c_char_ptr, data_len: c_size_t) -> None:
    try:
        # var msg = c_str_to_string(data, data_len)
        var msg = String(StringRef(data, data_len))
        ws_on_message_holder_ptr()[][id](msg)
    except e:
        pass


@value
struct WebSocket:
    var _ptr: c_void_ptr
    var _id: Int

    fn __init__(
        inout self,
        host: String,
        port: String,
        path: String,
        tls_version: Int = TLS1_3_VERSION,
    ) raises:
        var ptr = seq_websocket_new(
            host.unsafe_cstr_ptr(),
            port.unsafe_cstr_ptr(),
            path.unsafe_cstr_ptr(),
            tls_version,
        )
        register_websocket(ptr)
        logd("ws._ptr=" + str(seq_voidptr_to_int(ptr)))
        self._ptr = ptr
        self._id = seq_voidptr_to_int(ptr)

    fn c_ptr(self) -> c_void_ptr:
        return self._ptr

    fn get_id(self) -> Int:
        return self._id

    fn get_on_connected(self) -> on_connected_callback:
        var self_ptr = UnsafePointer.address_of(self)

        fn wrapper():
            self_ptr[].on_connected()

        return wrapper

    fn get_on_before_reconnect(self) -> on_before_reconnect_callback:
        var self_ptr = UnsafePointer.address_of(self)

        fn wrapper():
            self_ptr[].on_before_reconnect()

        return wrapper

    fn get_on_heartbeat(self) -> on_heartbeat_callback:
        var self_ptr = UnsafePointer.address_of(self)

        fn wrapper():
            self_ptr[].on_heartbeat()

        return wrapper

    fn get_on_message(self) -> on_message_callback:
        var self_ptr = UnsafePointer.address_of(self)

        fn wrapper(msg: String):
            self_ptr[].on_message(msg)

        return wrapper

    fn on_connected(self) -> None:
        logd("WebSocket.on_connected")

    fn on_before_reconnect(self) -> None:
        logd("WebSocket.on_before_reconnect")

    fn on_heartbeat(self) -> None:
        logd("WebSocket.on_heartbeat")

    fn on_message(self, msg: String) -> None:
        logd("WebSocket::on_message: " + msg)

    fn release(self) -> None:
        seq_websocket_delete(self._ptr)

    fn set_headers(self, headers: Dict[String, String]) -> None:
        var headers_ = SSMap()
        try:
            for key in headers.keys():
                # logi("key=" + key[] + " value=" + headers[key[]])
                headers_[key[]] = headers[key[]]
        except:
            pass
        seq_websocket_set_headers(self._ptr, headers_.ptr)

    fn connect(self):
        seq_websocket_connect(self._ptr)

    fn close(self):
        # seq_websocket_close(self.ws)
        pass

    fn send(self, text: String) -> None:
        seq_websocket_send(
            self._ptr,
            text.unsafe_cstr_ptr(),
            len(text),
        )

    fn __repr__(self) -> String:
        return "<WebSocket: ws={self._ptr}>"


fn websocket_connected_callback(ws: c_void_ptr) raises -> None:
    var id = seq_voidptr_to_int(ws)
    emit_on_connected(id)


fn websocket_on_before_reconnect_callback(ws: c_void_ptr) raises -> None:
    var id = seq_voidptr_to_int(ws)
    emit_on_before_reconnect(id)


fn websocket_heartbeat_callback(ws: c_void_ptr) raises -> None:
    var id = seq_voidptr_to_int(ws)
    emit_on_heartbeat(id)
    # logi("websocket_heartbeat_callback done")


fn websocket_message_callback(
    ws: c_void_ptr, data: c_char_ptr, data_len: c_size_t
) raises -> None:
    # logi("websocket_message_callback")
    var id = seq_voidptr_to_int(ws)
    emit_on_message(id, data, data_len)
    # logi("websocket_message_callback done")


fn register_websocket(ws: c_void_ptr) -> None:
    seq_websocket_set_on_connected(ws, websocket_connected_callback)
    seq_websocket_set_on_before_reconnect(
        ws, websocket_on_before_reconnect_callback
    )
    seq_websocket_set_on_heartbeat(ws, websocket_heartbeat_callback)
    seq_websocket_set_on_message(ws, websocket_message_callback)
