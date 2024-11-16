from sys.ffi import _get_global
import sys.ffi
from memory import memcpy, memset_zero, UnsafePointer
from sys.ffi import DLHandle
from sys.ffi import c_char, c_size_t, c_int
from utils import StringRef


# SDL_gfx
# https://github.com/modularml/mojo/issues/3520

# TODO: This is so we dont have to carry around aliases to function types,
#       since __type_of currently doesnt work for this. Maybe this could
#       be taken further to abstract away the secondary functions as well,
#       but using variadic packs here doesnt work yet, so i'm not sure yet.
@register_passable("trivial")
struct DL_Fn[name: String, T: AnyTrivialRegType]:
    var call: T

    @always_inline("nodebug")
    fn __init__(inout self, _handle: DLHandle):
        self.call = _handle.get_function[T](name)


# Websocket callbacks
alias OnConnectCallback = fn (c_void_ptr) raises -> None
alias OnBeforeReconnectCallback = fn (c_void_ptr) raises -> None
alias OnHeartbeatCallback = fn (c_void_ptr) raises -> None
alias OnMessageCallback = fn (
    c_void_ptr, c_char_ptr, c_size_t
) raises -> None


var __wrapper = _DLWrapper()


@value
struct _DLWrapper:
    var _handle: DLHandle

    var _seq_voidptr_to_int: DL_Fn[
        "seq_voidptr_to_int", fn (c_void_ptr) -> Int
    ]

    var _seq_int_to_voidptr: DL_Fn[
        "seq_int_to_voidptr", fn (Int) -> c_void_ptr
    ]

    var _seq_set_log_output_level: DL_Fn[
        "seq_set_log_output_level", fn (UInt8) -> NoneType
    ]
    var _seq_logvd: DL_Fn[
        "seq_logvd", fn (UnsafePointer[c_char], c_int) -> NoneType
    ]
    var _seq_logvi: DL_Fn[
        "seq_logvi", fn (UnsafePointer[c_char], c_int) -> NoneType
    ]
    var _seq_logvw: DL_Fn[
        "seq_logvw", fn (UnsafePointer[c_char], c_int) -> NoneType
    ]
    var _seq_logve: DL_Fn[
        "seq_logve", fn (UnsafePointer[c_char], c_int) -> NoneType
    ]

    # ssmap
    var _seq_ssmap_new: DL_Fn["seq_ssmap_new", fn () -> c_void_ptr]
    var _seq_ssmap_free: DL_Fn[
        "seq_ssmap_free", fn (p: c_void_ptr) -> None
    ]
    var _seq_ssmap_set: DL_Fn[
        "seq_ssmap_set",
        fn (
            p: c_void_ptr, name: c_char_ptr, value: c_char_ptr
        ) -> None,
    ]
    var _seq_ssmap_get: DL_Fn[
        "seq_ssmap_get",
        fn (
            p: c_void_ptr, name: c_char_ptr, n: UnsafePointer[c_size_t]
        ) -> c_char_ptr,
    ]
    var _seq_ssmap_size: DL_Fn[
        "seq_ssmap_size", fn (p: c_void_ptr) -> c_size_t
    ]

    # sha512
    var _seq_sha512: DL_Fn[
        "seq_sha512",
        fn (
            message: UnsafePointer[c_char],
            message_len: c_size_t,
            result: c_void_ptr,
        ) -> c_size_t,
    ]

    # hmac
    var _seq_hmac_sha256: DL_Fn[
        "seq_hmac_sha256",
        fn (
            key: UnsafePointer[c_char],
            key_len: c_size_t,
            message: UnsafePointer[c_char],
            message_len: c_size_t,
            result: c_void_ptr,
        ) -> c_size_t,
    ]
    var _seq_hmac_sha512: DL_Fn[
        "seq_hmac_sha512",
        fn (
            key: UnsafePointer[c_char],
            key_len: c_size_t,
            message: UnsafePointer[c_char],
            message_len: c_size_t,
            result: c_void_ptr,
        ) -> c_size_t,
    ]
    var _seq_hex_encode: DL_Fn[
        "seq_hex_encode",
        fn (input: c_void_ptr, n: c_size_t, result: c_void_ptr) -> Int,
    ]

    # HttpClient
    var _seq_ct_init: DL_Fn["seq_ct_init", fn() -> Int]
    var _seq_photon_init_default: DL_Fn["seq_photon_init_default", fn() -> Int]
    var _seq_cclient_new: DL_Fn["seq_cclient_new", fn(
        base_url: c_char_ptr, base_url_len: Int, method: Int
    ) -> c_void_ptr]
    var _seq_cclient_free: DL_Fn["seq_cclient_free", fn(client: c_void_ptr) -> None]
    var _seq_cclient_do_request: DL_Fn["seq_cclient_do_request", fn(
        client: c_void_ptr,
        path: c_char_ptr,
        path_len: c_size_t,
        verb: Int,
        headers: c_void_ptr,
        body: c_char_ptr,
        body_len: c_size_t,
        res: c_void_ptr,
        res_len: c_size_t,
        n: UnsafePointer[Int],
        verbose: Bool = False,
    ) -> Int]

    # Websocket
    var _seq_asio_ioc: DL_Fn["seq_asio_ioc", fn () -> c_void_ptr]
    var _seq_asio_run: DL_Fn["seq_asio_run", fn (ioc: c_void_ptr) -> None]
    var _seq_asio_run_ex: DL_Fn["seq_asio_run_ex", fn(ioc: c_void_ptr, bind_cpu: c_int, pool: Bool) -> None]
    var _seq_asio_ioc_poll: DL_Fn[
        "seq_asio_ioc_poll", fn (ioc: c_void_ptr) -> None
    ]
    var _seq_websocket_new: DL_Fn[
        "seq_websocket_new",
        fn (
            host: c_char_ptr,
            port: c_char_ptr,
            path: c_char_ptr,
            tls_version: Int,
        ) -> c_void_ptr,
    ]
    var _seq_websocket_delete: DL_Fn[
        "seq_websocket_delete", fn (p: c_void_ptr) -> None
    ]
    var _seq_websocket_connect: DL_Fn[
        "seq_websocket_connect", fn (p: c_void_ptr) -> None
    ]
    var _seq_websocket_set_headers: DL_Fn[
        "seq_websocket_set_headers",
        fn (p: c_void_ptr, headers: c_void_ptr) -> None,
    ]
    var _seq_websocket_disconnect: DL_Fn[
        "seq_websocket_disconnect", fn (p: c_void_ptr) -> None
    ]
    var _seq_websocket_set_on_connected: DL_Fn[
        "seq_websocket_set_on_connected",
        fn (p: c_void_ptr, cb: OnConnectCallback) -> None,
    ]
    var _seq_websocket_set_on_before_reconnect: DL_Fn[
        "seq_websocket_set_on_before_reconnect",
        fn (p: c_void_ptr, cb: OnBeforeReconnectCallback) -> None,
    ]
    var _seq_websocket_set_on_heartbeat: DL_Fn[
        "seq_websocket_set_on_heartbeat",
        fn (p: c_void_ptr, cb: OnHeartbeatCallback) -> None,
    ]
    var _seq_websocket_set_on_message: DL_Fn[
        "seq_websocket_set_on_message",
        fn (p: c_void_ptr, cb: OnMessageCallback) -> None,
    ]
    var _seq_websocket_send: DL_Fn[
        "seq_websocket_send",
        fn (p: c_void_ptr, text: c_char_ptr, len: c_size_t) -> None,
    ]

    var _seq_nanoid: DL_Fn["seq_nanoid", fn (result: c_char_ptr) -> c_size_t]

    # fn __init__(inout self):
    #     __mlir_op.`lit.ownership.mark_initialized`(__get_mvalue_as_litref(self))

    fn __init__(inout self):
        self._handle = DLHandle(LIBNAME)

        self._seq_voidptr_to_int = self._handle
        self._seq_int_to_voidptr = self._handle

        self._seq_set_log_output_level = self._handle
        self._seq_logvd = self._handle
        self._seq_logvi = self._handle
        self._seq_logvw = self._handle
        self._seq_logve = self._handle

        self._seq_ssmap_new = self._handle
        self._seq_ssmap_free = self._handle
        self._seq_ssmap_set = self._handle
        self._seq_ssmap_get = self._handle
        self._seq_ssmap_size = self._handle

        self._seq_sha512 = self._handle

        self._seq_hmac_sha256 = self._handle
        self._seq_hmac_sha512 = self._handle
        self._seq_hex_encode = self._handle

        self._seq_ct_init = self._handle
        self._seq_photon_init_default = self._handle
        self._seq_cclient_new = self._handle
        self._seq_cclient_free = self._handle
        self._seq_cclient_do_request = self._handle

        self._seq_asio_ioc = self._handle
        self._seq_asio_run = self._handle
        self._seq_asio_run_ex = self._handle
        self._seq_asio_ioc_poll = self._handle
        self._seq_websocket_new = self._handle
        self._seq_websocket_delete = self._handle
        self._seq_websocket_connect = self._handle
        self._seq_websocket_set_headers = self._handle
        self._seq_websocket_disconnect = self._handle
        self._seq_websocket_set_on_connected = self._handle
        self._seq_websocket_set_on_before_reconnect = self._handle
        self._seq_websocket_set_on_heartbeat = self._handle
        self._seq_websocket_set_on_message = self._handle
        self._seq_websocket_send = self._handle

        self._seq_nanoid = self._handle

        # var i = str(self._handle.handle.bitcast[UInt8]())
        # print("_EH i=" + str(i))

        _ = self._seq_ct_init.call()
        _ = self._seq_photon_init_default.call()
        print("ct")

@always_inline
fn seq_voidptr_to_int(p: c_void_ptr) -> Int:
    return __wrapper._seq_voidptr_to_int.call(p)

@always_inline
fn seq_int_to_voidptr(i: Int) -> c_void_ptr:
    return __wrapper._seq_int_to_voidptr.call(i)

@always_inline
fn seq_set_log_output_level(
    level: UInt8
):
    __wrapper._seq_set_log_output_level.call(level)

@always_inline
fn seq_logvd(s: UnsafePointer[c_char], length: c_int):
    __wrapper._seq_logvd.call(s, length)

@always_inline
fn seq_logvi(s: UnsafePointer[c_char], length: c_int):
    __wrapper._seq_logvi.call(s, length)

@always_inline
fn seq_logvw(s: UnsafePointer[c_char], length: c_int):
    __wrapper._seq_logvw.call(s, length)

@always_inline
fn seq_logve(s: UnsafePointer[c_char], length: c_int):
    __wrapper._seq_logve.call(s, length)

@always_inline
fn seq_ssmap_new() -> c_void_ptr:
    return __wrapper._seq_ssmap_new.call()

@always_inline
fn seq_ssmap_free(ptr: c_void_ptr) -> None:
    __wrapper._seq_ssmap_free.call(ptr)

@always_inline
fn seq_ssmap_set(
    ptr: c_void_ptr,
    key: UnsafePointer[c_char],
    value: UnsafePointer[c_char],
) -> None:
    __wrapper._seq_ssmap_set.call(ptr, key, value)

@always_inline
fn seq_ssmap_get(
    ptr: c_void_ptr, key: UnsafePointer[c_char], n: UnsafePointer[c_size_t]
) -> c_char_ptr:
    return __wrapper._seq_ssmap_get.call(ptr, key, n)

@always_inline
fn seq_ssmap_size(ptr: c_void_ptr) -> c_size_t:
    return __wrapper._seq_ssmap_size.call(ptr)

alias SHA512_DIGEST_LENGTH	=	64

@always_inline
fn seq_sha512(
    message: UnsafePointer[c_char],
    message_len: c_size_t,
    result: c_void_ptr,
) -> c_size_t:
    return __wrapper._seq_sha512.call(
        message, message_len, result
    )


@always_inline
fn seq_hmac_sha256(
    key: UnsafePointer[c_char],
    key_len: c_size_t,
    message: UnsafePointer[c_char],
    message_len: c_size_t,
    result: c_void_ptr,
) -> c_size_t:
    return __wrapper._seq_hmac_sha256.call(
        key, key_len, message, message_len, result
    )

@always_inline
fn seq_hmac_sha512(
    key: UnsafePointer[c_char],
    key_len: c_size_t,
    message: UnsafePointer[c_char],
    message_len: c_size_t,
    result: c_void_ptr,
) -> c_size_t:
    return __wrapper._seq_hmac_sha512.call(
        key, key_len, message, message_len, result
    )

@always_inline
fn seq_hex_encode(
    input: c_void_ptr, n: c_size_t, result: c_void_ptr
) -> Int:
    return __wrapper._seq_hex_encode.call(input, n, result)

@always_inline
fn seq_ct_init() -> Int:
    return __wrapper._seq_ct_init.call()

@always_inline
fn seq_photon_init_default() -> Int:
    return __wrapper._seq_photon_init_default.call()

@always_inline
fn seq_cclient_new(
    base_url: c_char_ptr,
    base_url_len: Int,
    method: Int
) -> c_void_ptr:
    return __wrapper._seq_cclient_new.call(base_url, base_url_len, method)

@always_inline
fn seq_cclient_free(client: c_void_ptr) -> None:
    __wrapper._seq_cclient_free.call(client)

@always_inline
fn seq_cclient_do_request(
    client: c_void_ptr,
    path: c_char_ptr,
    path_len: c_size_t,
    verb: Int,
    headers: c_void_ptr,
    body: c_char_ptr,
    body_len: c_size_t,
    res: c_void_ptr,
    res_len: c_size_t,
    n: UnsafePointer[Int],
    verbose: Bool = False,
) -> Int:
    return __wrapper._seq_cclient_do_request.call(
        client, path, path_len, verb, headers, body, body_len, res, res_len, n, verbose
    )

@always_inline
fn seq_asio_ioc() -> c_void_ptr:
    return __wrapper._seq_asio_ioc.call()

@always_inline
fn seq_asio_run(ioc: c_void_ptr) -> None:
    __wrapper._seq_asio_run.call(ioc)

@always_inline
fn seq_asio_run_ex(ioc: c_void_ptr, bind_cpu: c_int = -1, pool: Bool = False) -> None:
    __wrapper._seq_asio_run_ex.call(ioc, bind_cpu, pool)

@always_inline
fn seq_asio_ioc_poll(ioc: c_void_ptr) -> None:
    __wrapper._seq_asio_ioc_poll.call(ioc)

@always_inline
fn seq_websocket_set_on_connected(
    p: c_void_ptr, cb: OnConnectCallback
) -> None:
    __wrapper._seq_websocket_set_on_connected.call(p, cb)

@always_inline
fn seq_websocket_set_on_before_reconnect(
    p: c_void_ptr, cb: OnBeforeReconnectCallback
) -> None:
    __wrapper._seq_websocket_set_on_before_reconnect.call(p, cb)

@always_inline
fn seq_websocket_set_on_heartbeat(
    p: c_void_ptr, cb: OnHeartbeatCallback
) -> None:
    __wrapper._seq_websocket_set_on_heartbeat.call(p, cb)

@always_inline
fn seq_websocket_set_on_message(
    p: c_void_ptr, cb: OnMessageCallback
) -> None:
    __wrapper._seq_websocket_set_on_message.call(p, cb)

@always_inline
fn seq_websocket_new(
    host: c_char_ptr,
    port: c_char_ptr,
    path: c_char_ptr,
    tls_version: Int,
) -> c_void_ptr:
    return __wrapper._seq_websocket_new.call(host, port, path, tls_version)

@always_inline
fn seq_websocket_delete(p: c_void_ptr) -> None:
    __wrapper._seq_websocket_delete.call(p)

@always_inline
fn seq_websocket_connect(p: c_void_ptr) -> None:
    __wrapper._seq_websocket_connect.call(p)

@always_inline
fn seq_websocket_set_headers(
    p: c_void_ptr, headers: c_void_ptr
) -> None:
    __wrapper._seq_websocket_set_headers.call(p, headers)

@always_inline
fn seq_websocket_disconnect(p: c_void_ptr) -> None:
    __wrapper._seq_websocket_disconnect.call(p)

@always_inline
fn seq_websocket_send(
    p: c_void_ptr, text: c_char_ptr, len: c_size_t
) -> None:
    __wrapper._seq_websocket_send.call(p, text, len)

@always_inline
fn seq_nanoid() -> String:
    var result = UnsafePointer[Int8].alloc(32)
    var len = __wrapper._seq_nanoid.call(result)
    return String(ptr=result.bitcast[UInt8](), length=len + 1)
