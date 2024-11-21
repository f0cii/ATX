struct TlsContext:
    var ctx: c_void_ptr

    fn __init__(out self) -> None:
        self.ctx = photon_net_tls_context_new()

    fn __moveinit__(out self, owned other: TlsContext) -> None:
        # print("TlsContext.__moveinit__")
        self.ctx = other.ctx

    fn __del__(owned self) -> None:
        # print("TlsContext.__del__")
        photon_net_tls_context_destory(self.ctx)


struct HttpClient:
    var _ctx: TlsContext
    var _client: c_void_ptr

    @always_inline
    fn __init__(out self):
        self._ctx = TlsContext()
        self._client = photon_net_http_client_new(self._ctx.ctx)

    @always_inline
    fn __moveinit__(out self, owned other: HttpClient) -> None:
        # print("HttpClient.__moveinit__")
        self._ctx = other._ctx^
        self._client = other._client

    @always_inline
    fn __del__(owned self) -> None:
        # print("HttpClient.__del__")
        photon_net_http_client_destroy(self._client)

    @always_inline
    fn set_proxy(self, proxy: String) -> None:
        photon_net_http_client_set_proxy(self._client, proxy.unsafe_cstr_ptr())
        photon_net_http_client_enable_proxy(self._client)

    @always_inline
    fn set_user_agent(self, user_agent: String) -> None:
        photon_net_http_client_set_user_agent(
            self._client, user_agent.unsafe_cstr_ptr()
        )

    @always_inline
    fn set_timeout_ms(self, timeout_ms: Int) -> None:
        photon_net_http_client_set_timeout_ms(self._client, timeout_ms)

    # @always_inline
    # fn new_operation[L: MutableOrigin](
    #     inout self, verb: Verb, url: String, buf_size: Int
    # ) -> ref [self] HttpClientOperation[L]:
    #     return HttpClientOperation(self, verb, url, buf_size)


struct HttpClientOperation[origin: MutableOrigin]:
    var _op: c_void_ptr
    var _client: Pointer[HttpClient, origin]

    @always_inline
    fn __init__(
        inout self,
        ref [origin]client: HttpClient,
        verb: Verb,
        url: String,
        buf_size: Int = 1024,
    ):
        self._op = photon_net_http_client_new_operation(
            client._client,
            verb._value,
            url.unsafe_cstr_ptr(),
            len(url),
            buf_size,
        )
        self._client = Pointer.address_of(client)

    @always_inline
    fn __del__(owned self) -> None:
        # print("HttpClientOperation.__del__")
        photon_net_http_client_operation_destroy(
            self._client[]._client, self._op
        )

    @always_inline
    fn call(self) -> Int:
        return photon_net_http_client_operation_call(self._op)

    @always_inline
    fn status_code(self) -> Int:
        return photon_net_http_client_operation_status_code(self._op)

    @always_inline
    fn status_message(self) -> StringRef:
        var status_message_len = c_size_t(0)
        var status_message = photon_net_http_client_operation_status_message(
            self._op, UnsafePointer.address_of(status_message_len)
        )
        return StringRef(status_message, status_message_len.value)

    @always_inline
    fn read(self, buf: UnsafePointer[Int8], buf_size: Int) -> Int:
        return photon_net_http_client_operation_read(self._op, buf, buf_size)

    @always_inline
    fn read_all(self) -> String:
        var res_size = photon_net_http_client_operation_resource_size(self._op)
        if res_size == 0:
            return ""
        var buf = UnsafePointer[Int8].alloc(res_size)
        var ret_size = photon_net_http_client_operation_read(
            self._op, buf, res_size
        )
        var s_ref = StringRef(buf, ret_size)
        var s = String(s_ref)
        buf.free()
        return s

    # @always_inline
    # fn read_all(self) -> String:
    #     var res_size = c_size_t(0)
    #     var s_ = photon_net_http_client_operation_read_all(
    #         self._op, UnsafePointer.address_of(res_size)
    #     )
    #     # print("res_size: " + str(res_size))
    #     var s_ref = StringRef(s_, res_size)
    #     var s = String(s_ref)
    #     photon_free_string(s_)
    #     return s
