from .base import *


alias ALOG_DEBUG = 0
alias ALOG_INFO = 1
alias ALOG_WARN = 2
alias ALOG_ERROR = 3
alias ALOG_FATAL = 4
alias ALOG_TEMP = 5
alias ALOG_AUDIT = 6


fn SHIFT(n: c_uint) -> c_uint:
    return 1 << n


alias INIT_EVENT_NONE: c_uint = 0
alias INIT_EVENT_EPOLL: c_uint = SHIFT(0)
alias INIT_EVENT_IOURING: c_uint = SHIFT(1)
alias INIT_EVENT_SELECT: c_uint = SHIFT(2)
alias INIT_EVENT_KQUEUE: c_uint = SHIFT(3)
alias INIT_EVENT_IOCP: c_uint = SHIFT(4)
alias INIT_EVENT_EPOLL_NG: c_uint = SHIFT(5)
alias INIT_EVENT_SIGNAL: c_uint = SHIFT(10)

alias INIT_IO_NONE: c_uint = 0
alias INIT_IO_LIBAIO: c_uint = SHIFT(0)
alias INIT_IO_LIBCURL: c_uint = SHIFT(1)
alias INIT_IO_SOCKET_EDGE_TRIGGER: c_uint = SHIFT(2)
alias INIT_IO_EXPORTFS: c_uint = SHIFT(10)
alias INIT_IO_FSTACK_DPDK: c_uint = SHIFT(20)


@value
@register_passable("trivial")
struct PhotonOptions:
    var libaio_queue_depth: c_int32
    var use_pooled_stack_allocator: c_bool
    var bypass_threadpool: c_bool

    fn __init__(out self):
        self.libaio_queue_depth = 32
        self.use_pooled_stack_allocator = True
        self.bypass_threadpool = True


@value
@register_passable("trivial")
struct iovec:
    var iov_base: c_void_ptr
    var iov_len: c_size_t


alias fn_photon_set_log_output_level = fn (l: c_int) -> None

alias fn_photon_init = fn (
    event_engine: c_uint64,
    io_engine: c_uint64,
    options: UnsafePointer[PhotonOptions],
) -> c_int

alias fn_photon_fini = fn () -> None


alias TLSContextPtr = c_void_ptr

alias fn_photon_net_tls_context_new = fn () -> TLSContextPtr
alias fn_photon_net_tls_context_destory = fn (tls: TLSContextPtr) -> None

alias fn_photon_net_http_client_new = fn (tls: TLSContextPtr) -> UnsafePointer[
    c_void
]

alias fn_photon_net_http_client_destroy = fn (
    client: UnsafePointer[c_void]
) -> None

alias fn_photon_net_http_client_set_proxy = fn (
    client: UnsafePointer[c_void], proxy: c_char_ptr
) -> None

alias fn_photon_net_http_client_enable_proxy = fn (
    client: UnsafePointer[c_void]
) -> None

alias fn_photon_net_http_client_disable_proxy = fn (
    client: UnsafePointer[c_void]
) -> None

alias fn_photon_net_http_client_has_proxy = fn (
    client: UnsafePointer[c_void]
) -> c_bool

alias fn_photon_net_http_client_set_user_agent = fn (
    client: UnsafePointer[c_void], user_agent: c_char_ptr
) -> None

alias fn_photon_net_http_client_set_timeout = fn (
    client: UnsafePointer[c_void], timeout: c_uint64
) -> None

alias fn_photon_net_http_client_set_timeout_ms = fn (
    client: UnsafePointer[c_void], tmo: c_uint64
) -> None

alias fn_photon_net_http_client_new_operation = fn (
    client: UnsafePointer[c_void],
    verb: c_uint,
    url: c_char_ptr,
    url_len: c_size_t,
    buf_size: c_uint16,
) -> UnsafePointer[c_void]

alias fn_photon_net_http_client_operation_destroy = fn (
    client: UnsafePointer[c_void], op: UnsafePointer[c_void]
) -> None

alias fn_photon_net_http_client_operation_set_retry = fn (
    op: UnsafePointer[c_void], retry: c_int
) -> None

alias fn_photon_net_http_client_operation_set_timeout = fn (
    op: UnsafePointer[c_void], timeout: c_int
) -> None

alias fn_photon_net_http_client_operation_set_header = fn (
    op: UnsafePointer[c_void],
    key: c_char_ptr,
    value: c_char_ptr,
    allow_dup: c_int,
) -> None

alias fn_photon_net_http_client_operation_set_content_length = fn (
    op: UnsafePointer[c_void], cl: c_uint64
) -> None

alias fn_photon_net_http_client_operation_set_body = fn (
    op: UnsafePointer[c_void], body: c_char_ptr, body_len: c_size_t
) -> None

alias fn_photon_net_http_client_operation_call = fn (
    op: UnsafePointer[c_void]
) -> c_int

alias fn_photon_net_http_client_operation_status_code = fn (
    op: UnsafePointer[c_void]
) -> c_int

alias fn_photon_net_http_client_operation_status_message = fn (
    op: UnsafePointer[c_void], len: UnsafePointer[c_size_t]
) -> c_char_ptr

alias fn_photon_net_http_client_operation_resource_size = fn (
    op: UnsafePointer[c_void]
) -> c_size_t

alias fn_photon_net_http_client_operation_read = fn (
    op: UnsafePointer[c_void], buf: c_char_ptr, buf_size: c_size_t
) -> c_size_t

alias fn_photon_net_http_client_operation_readv = fn (
    op: UnsafePointer[c_void], iov: UnsafePointer[iovec], iov_size: c_size_t
) -> c_size_t

alias fn_photon_net_http_client_operation_read_all = fn (
    op: UnsafePointer[c_void], res_size: UnsafePointer[c_size_t]
) -> c_char_ptr

alias fn_photon_pooled_allocator_new = fn () -> c_void_ptr

alias fn_photon_pooled_allocator_destory = fn (allocator: c_void_ptr) -> None

alias fn_photon_pooled_allocator_new_io_alloc = fn (
    allocator: c_void_ptr
) -> c_void_ptr

alias fn_photon_io_alloc_alloc = fn (
    io_alloc: c_void_ptr, size: c_size_t
) -> c_void_ptr

alias fn_photon_io_alloc_dealloc = fn (
    io_alloc: c_void_ptr, ptr: c_void_ptr
) -> None

alias fn_photon_malloc = fn (size: c_size_t) -> c_void_ptr

alias fn_photon_free = fn (ptr: c_void_ptr) -> None

alias fn_photon_new_string = fn (size: c_size_t) -> c_char_ptr

alias fn_photon_free_string = fn (buf: c_char_ptr) -> None

var __wrapper = _DLWrapper()


@value
struct _DLWrapper:
    var _handle: DLHandle

    var _photon_set_log_output_level: fn_photon_set_log_output_level

    var _photon_init: fn_photon_init
    var _photon_fini: fn_photon_fini

    var _photon_net_tls_context_new: fn_photon_net_tls_context_new
    var _photon_net_tls_context_destory: fn_photon_net_tls_context_destory

    var _photon_net_http_client_new: fn_photon_net_http_client_new
    var _photon_net_http_client_destroy: fn_photon_net_http_client_destroy
    var _photon_net_http_client_set_proxy: fn_photon_net_http_client_set_proxy
    var _photon_net_http_client_enable_proxy: fn_photon_net_http_client_enable_proxy
    var _photon_net_http_client_disable_proxy: fn_photon_net_http_client_disable_proxy
    var _photon_net_http_client_has_proxy: fn_photon_net_http_client_has_proxy
    var _photon_net_http_client_set_user_agent: fn_photon_net_http_client_set_user_agent
    var _photon_net_http_client_set_timeout: fn_photon_net_http_client_set_timeout
    var _photon_net_http_client_set_timeout_ms: fn_photon_net_http_client_set_timeout_ms
    var _photon_net_http_client_new_operation: fn_photon_net_http_client_new_operation
    var _photon_net_http_client_operation_destroy: fn_photon_net_http_client_operation_destroy
    var _photon_net_http_client_operation_set_retry: fn_photon_net_http_client_operation_set_retry
    var _photon_net_http_client_operation_set_timeout: fn_photon_net_http_client_operation_set_timeout
    var _photon_net_http_client_operation_set_header: fn_photon_net_http_client_operation_set_header
    var _photon_net_http_client_operation_set_content_length: fn_photon_net_http_client_operation_set_content_length
    var _photon_net_http_client_operation_set_body: fn_photon_net_http_client_operation_set_body
    var _photon_net_http_client_operation_call: fn_photon_net_http_client_operation_call
    var _photon_net_http_client_operation_status_code: fn_photon_net_http_client_operation_status_code
    var _photon_net_http_client_operation_status_message: fn_photon_net_http_client_operation_status_message
    var _photon_net_http_client_operation_resource_size: fn_photon_net_http_client_operation_resource_size
    var _photon_net_http_client_operation_read: fn_photon_net_http_client_operation_read
    var _photon_net_http_client_operation_readv: fn_photon_net_http_client_operation_readv
    var _photon_net_http_client_operation_read_all: fn_photon_net_http_client_operation_read_all
    var _photon_pooled_allocator_new: fn_photon_pooled_allocator_new
    var _photon_pooled_allocator_destory: fn_photon_pooled_allocator_destory
    var _photon_pooled_allocator_new_io_alloc: fn_photon_pooled_allocator_new_io_alloc
    var _photon_io_alloc_alloc: fn_photon_io_alloc_alloc
    var _photon_io_alloc_dealloc: fn_photon_io_alloc_dealloc
    var _photon_malloc: fn_photon_malloc
    var _photon_free: fn_photon_free
    var _photon_new_string: fn_photon_new_string
    var _photon_free_string: fn_photon_free_string

    fn __init__(out self):
        self._handle = DLHandle(LIBNAME)

        self._photon_set_log_output_level = self._handle.get_function[
            fn_photon_set_log_output_level
        ]("photon_set_log_output_level")

        self._photon_init = self._handle.get_function[fn_photon_init](
            "photon_init"
        )
        self._photon_fini = self._handle.get_function[fn_photon_fini](
            "photon_fini"
        )

        self._photon_net_tls_context_new = self._handle.get_function[
            fn_photon_net_tls_context_new
        ]("photon_net_tls_context_new")
        self._photon_net_tls_context_destory = self._handle.get_function[
            fn_photon_net_tls_context_destory
        ]("photon_net_tls_context_destory")

        self._photon_net_http_client_new = self._handle.get_function[
            fn_photon_net_http_client_new
        ]("photon_net_http_client_new")
        self._photon_net_http_client_destroy = self._handle.get_function[
            fn_photon_net_http_client_destroy
        ]("photon_net_http_client_destroy")
        self._photon_net_http_client_set_proxy = self._handle.get_function[
            fn_photon_net_http_client_set_proxy
        ]("photon_net_http_client_set_proxy")
        self._photon_net_http_client_enable_proxy = self._handle.get_function[
            fn_photon_net_http_client_enable_proxy
        ]("photon_net_http_client_enable_proxy")
        self._photon_net_http_client_disable_proxy = self._handle.get_function[
            fn_photon_net_http_client_disable_proxy
        ]("photon_net_http_client_disable_proxy")
        self._photon_net_http_client_has_proxy = self._handle.get_function[
            fn_photon_net_http_client_has_proxy
        ]("photon_net_http_client_has_proxy")
        self._photon_net_http_client_set_user_agent = self._handle.get_function[
            fn_photon_net_http_client_set_user_agent
        ]("photon_net_http_client_set_user_agent")
        self._photon_net_http_client_set_timeout = self._handle.get_function[
            fn_photon_net_http_client_set_timeout
        ]("photon_net_http_client_set_timeout")
        self._photon_net_http_client_set_timeout_ms = self._handle.get_function[
            fn_photon_net_http_client_set_timeout_ms
        ]("photon_net_http_client_set_timeout_ms")
        self._photon_net_http_client_new_operation = self._handle.get_function[
            fn_photon_net_http_client_new_operation
        ]("photon_net_http_client_new_operation")
        self._photon_net_http_client_operation_destroy = (
            self._handle.get_function[
                fn_photon_net_http_client_operation_destroy
            ]("photon_net_http_client_operation_destroy")
        )
        self._photon_net_http_client_operation_set_retry = (
            self._handle.get_function[
                fn_photon_net_http_client_operation_set_retry
            ]("photon_net_http_client_operation_set_retry")
        )
        self._photon_net_http_client_operation_set_timeout = (
            self._handle.get_function[
                fn_photon_net_http_client_operation_set_timeout
            ]("photon_net_http_client_operation_set_timeout")
        )
        self._photon_net_http_client_operation_set_header = (
            self._handle.get_function[
                fn_photon_net_http_client_operation_set_header
            ]("photon_net_http_client_operation_set_header")
        )
        self._photon_net_http_client_operation_set_content_length = (
            self._handle.get_function[
                fn_photon_net_http_client_operation_set_content_length
            ]("photon_net_http_client_operation_set_content_length")
        )
        self._photon_net_http_client_operation_set_body = (
            self._handle.get_function[
                fn_photon_net_http_client_operation_set_body
            ]("photon_net_http_client_operation_set_body")
        )
        self._photon_net_http_client_operation_call = self._handle.get_function[
            fn_photon_net_http_client_operation_call
        ]("photon_net_http_client_operation_call")
        self._photon_net_http_client_operation_status_code = (
            self._handle.get_function[
                fn_photon_net_http_client_operation_status_code
            ]("photon_net_http_client_operation_status_code")
        )
        self._photon_net_http_client_operation_status_message = (
            self._handle.get_function[
                fn_photon_net_http_client_operation_status_message
            ]("photon_net_http_client_operation_status_message")
        )
        self._photon_net_http_client_operation_resource_size = (
            self._handle.get_function[
                fn_photon_net_http_client_operation_resource_size
            ]("photon_net_http_client_operation_resource_size")
        )
        self._photon_net_http_client_operation_read = self._handle.get_function[
            fn_photon_net_http_client_operation_read
        ]("photon_net_http_client_operation_read")
        self._photon_net_http_client_operation_readv = (
            self._handle.get_function[
                fn_photon_net_http_client_operation_readv
            ]("photon_net_http_client_operation_readv")
        )
        self._photon_net_http_client_operation_read_all = (
            self._handle.get_function[
                fn_photon_net_http_client_operation_read_all
            ]("photon_net_http_client_operation_read_all")
        )
        self._photon_pooled_allocator_new = self._handle.get_function[
            fn_photon_pooled_allocator_new
        ]("photon_pooled_allocator_new")
        self._photon_pooled_allocator_destory = self._handle.get_function[
            fn_photon_pooled_allocator_destory
        ]("photon_pooled_allocator_destory")
        self._photon_pooled_allocator_new_io_alloc = self._handle.get_function[
            fn_photon_pooled_allocator_new_io_alloc
        ]("photon_pooled_allocator_new_io_alloc")
        self._photon_io_alloc_alloc = self._handle.get_function[
            fn_photon_io_alloc_alloc
        ]("photon_io_alloc_alloc")
        self._photon_io_alloc_dealloc = self._handle.get_function[
            fn_photon_io_alloc_dealloc
        ]("photon_io_alloc_dealloc")
        self._photon_malloc = self._handle.get_function[fn_photon_malloc](
            "photon_malloc"
        )
        self._photon_free = self._handle.get_function[fn_photon_free](
            "photon_free"
        )
        self._photon_new_string = self._handle.get_function[
            fn_photon_new_string
        ]("photon_new_string")
        self._photon_free_string = self._handle.get_function[
            fn_photon_free_string
        ]("photon_free_string")


@always_inline
fn photon_set_log_output_level(l: c_int) -> None:
    return __wrapper._photon_set_log_output_level(l)


@always_inline
fn photon_init(
    event_engine: c_uint, io_engine: c_uint, options: PhotonOptions
) -> c_int:
    return __wrapper._photon_init(
        event_engine, io_engine, UnsafePointer.address_of(options)
    )


@always_inline
fn photon_fini() -> None:
    return __wrapper._photon_fini()


@always_inline
fn photon_net_tls_context_new() -> TLSContextPtr:
    return __wrapper._photon_net_tls_context_new()


@always_inline
fn photon_net_tls_context_destory(tls: TLSContextPtr) -> None:
    return __wrapper._photon_net_tls_context_destory(tls)


@always_inline
fn photon_net_http_client_new(tls: TLSContextPtr) -> UnsafePointer[c_void]:
    return __wrapper._photon_net_http_client_new(tls)


@always_inline
fn photon_net_http_client_destroy(client: UnsafePointer[c_void]) -> None:
    return __wrapper._photon_net_http_client_destroy(client)


@always_inline
fn photon_net_http_client_set_proxy(
    client: UnsafePointer[c_void], proxy: c_char_ptr
) -> None:
    return __wrapper._photon_net_http_client_set_proxy(client, proxy)


@always_inline
fn photon_net_http_client_enable_proxy(client: UnsafePointer[c_void]) -> None:
    return __wrapper._photon_net_http_client_enable_proxy(client)


@always_inline
fn photon_net_http_client_disable_proxy(client: UnsafePointer[c_void]) -> None:
    return __wrapper._photon_net_http_client_disable_proxy(client)


@always_inline
fn photon_net_http_client_has_proxy(client: UnsafePointer[c_void]) -> c_bool:
    return __wrapper._photon_net_http_client_has_proxy(client)


@always_inline
fn photon_net_http_client_set_user_agent(
    client: UnsafePointer[c_void], user_agent: c_char_ptr
) -> None:
    return __wrapper._photon_net_http_client_set_user_agent(client, user_agent)


@always_inline
fn photon_net_http_client_set_timeout(
    client: UnsafePointer[c_void], timeout: c_uint64
) -> None:
    return __wrapper._photon_net_http_client_set_timeout(client, timeout)


@always_inline
fn photon_net_http_client_set_timeout_ms(
    client: UnsafePointer[c_void], tmo: c_uint64
) -> None:
    return __wrapper._photon_net_http_client_set_timeout_ms(client, tmo)


@always_inline
fn photon_net_http_client_new_operation(
    client: UnsafePointer[c_void],
    verb: c_uint,
    url: c_char_ptr,
    url_len: c_size_t,
    buf_size: c_uint16,
) -> UnsafePointer[c_void]:
    return __wrapper._photon_net_http_client_new_operation(
        client, verb, url, url_len, buf_size
    )


@always_inline
fn photon_net_http_client_operation_destroy(
    client: UnsafePointer[c_void], op: UnsafePointer[c_void]
) -> None:
    return __wrapper._photon_net_http_client_operation_destroy(client, op)


@always_inline
fn photon_net_http_client_operation_set_retry(
    op: UnsafePointer[c_void], retry: c_int
) -> None:
    return __wrapper._photon_net_http_client_operation_set_retry(op, retry)


@always_inline
fn photon_net_http_client_operation_set_timeout(
    op: UnsafePointer[c_void], timeout: c_int
) -> None:
    return __wrapper._photon_net_http_client_operation_set_timeout(op, timeout)


@always_inline
fn photon_net_http_client_operation_set_header(
    op: UnsafePointer[c_void],
    key: c_char_ptr,
    value: c_char_ptr,
    allow_dup: c_int,
) -> None:
    return __wrapper._photon_net_http_client_operation_set_header(
        op, key, value, allow_dup
    )


@always_inline
fn photon_net_http_client_operation_set_content_length(
    op: UnsafePointer[c_void], cl: c_uint64
) -> None:
    return __wrapper._photon_net_http_client_operation_set_content_length(
        op, cl
    )


@always_inline
fn photon_net_http_client_operation_set_body(
    op: UnsafePointer[c_void], body: c_char_ptr, body_len: c_size_t
) -> None:
    return __wrapper._photon_net_http_client_operation_set_body(
        op, body, body_len
    )


@always_inline
fn photon_net_http_client_operation_call(op: UnsafePointer[c_void]) -> c_int:
    return __wrapper._photon_net_http_client_operation_call(op)


@always_inline
fn photon_net_http_client_operation_status_code(
    op: UnsafePointer[c_void],
) -> c_int:
    return __wrapper._photon_net_http_client_operation_status_code(op)


@always_inline
fn photon_net_http_client_operation_status_message(
    op: UnsafePointer[c_void], len: UnsafePointer[c_size_t]
) -> c_char_ptr:
    return __wrapper._photon_net_http_client_operation_status_message(op, len)


@always_inline
fn photon_net_http_client_operation_resource_size(op: UnsafePointer[c_void]) -> c_size_t:
    return __wrapper._photon_net_http_client_operation_resource_size(op)


@always_inline
fn photon_net_http_client_operation_read(
    op: UnsafePointer[c_void], buf: c_char_ptr, buf_size: c_size_t
) -> c_size_t:
    return __wrapper._photon_net_http_client_operation_read(op, buf, buf_size)


@always_inline
fn photon_net_http_client_operation_readv(
    op: UnsafePointer[c_void], iov: UnsafePointer[iovec], iov_size: c_size_t
) -> c_size_t:
    return __wrapper._photon_net_http_client_operation_readv(op, iov, iov_size)


@always_inline
fn photon_net_http_client_operation_read_all(
    op: UnsafePointer[c_void], res_size: UnsafePointer[c_size_t]
) -> c_char_ptr:
    return __wrapper._photon_net_http_client_operation_read_all(op, res_size)


@always_inline
fn photon_pooled_allocator_new() -> c_void_ptr:
    return __wrapper._photon_pooled_allocator_new()


@always_inline
fn photon_pooled_allocator_destory(allocator: c_void_ptr) -> None:
    return __wrapper._photon_pooled_allocator_destory(allocator)


@always_inline
fn photon_pooled_allocator_new_io_alloc(allocator: c_void_ptr) -> c_void_ptr:
    return __wrapper._photon_pooled_allocator_new_io_alloc(allocator)


@always_inline
fn photon_io_alloc_alloc(io_alloc: c_void_ptr, size: c_size_t) -> c_void_ptr:
    return __wrapper._photon_io_alloc_alloc(io_alloc, size)


@always_inline
fn photon_io_alloc_dealloc(io_alloc: c_void_ptr, ptr: c_void_ptr) -> None:
    return __wrapper._photon_io_alloc_dealloc(io_alloc, ptr)


@always_inline
fn photon_malloc(size: c_size_t) -> c_void_ptr:
    return __wrapper._photon_malloc(size)


@always_inline
fn photon_free(ptr: c_void_ptr) -> None:
    return __wrapper._photon_free(ptr)


@always_inline
fn photon_new_string(size: c_size_t) -> c_char_ptr:
    return __wrapper._photon_new_string(size)


@always_inline
fn photon_free_string(buf: c_char_ptr) -> None:
    return __wrapper._photon_free_string(buf)
