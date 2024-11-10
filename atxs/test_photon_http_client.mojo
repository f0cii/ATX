from testing import assert_equal, assert_true
from os import getenv


fn test_photon_http_client() raises -> None:
    photon_set_log_output_level(ALOG_DEBUG)

    var wsl_distro_name = getenv("WSL_DISTRO_NAME")
    # assert_true(wsl_distro_name != "")
    # assert_equal(wsl_distro_name, "Ubuntu-22.04")

    var options = PhotonOptions()
    var event_engine = INIT_EVENT_IOURING if wsl_distro_name == "" else INIT_EVENT_EPOLL
    print(event_engine)
    var ret = photon_init(event_engine, INIT_IO_NONE, options)
    assert_equal(ret, 0)

    var tls_context = photon_net_tls_context_new()
    assert_true(tls_context != c_nullptr)

    var http_client = photon_net_http_client_new(tls_context)
    assert_true(http_client != c_nullptr)

    # var proxy = String("http://192.168.2.100:1080")
    # photon_net_http_client_set_proxy(http_client, proxy.unsafe_cstr_ptr())
    # photon_net_http_client_enable_proxy(http_client)
    # assert_true(photon_net_http_client_has_proxy(http_client))

    var user_agent = String(
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML,"
        " like Gecko) Chrome/58.0.3029.110 Safari/537.3"
    )
    photon_net_http_client_set_user_agent(
        http_client, user_agent.unsafe_cstr_ptr()
    )

    var timeout = 1000 * 10
    photon_net_http_client_set_timeout_ms(http_client, timeout)

    var verb = Verb.GET
    var url = String("https://www.baidu.com")
    # var url = String("https://eapi.binance.com/eapi/v1/time")
    var op = photon_net_http_client_new_operation(
        http_client, verb._value, url.unsafe_cstr_ptr(), len(url), 1024
    )
    assert_true(op != c_nullptr)

    # var key = String("user-agent")
    # var value = String("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36")
    # photon_net_http_client_operation_set_header(
    #     op, key.unsafe_cstr_ptr(), value.unsafe_cstr_ptr(), 0
    # )

    var call_ret = photon_net_http_client_operation_call(op)
    assert_equal(call_ret, 0)

    var status_code = photon_net_http_client_operation_status_code(op)
    assert_equal(status_code, 200)

    var status_message_len = c_size_t(0)
    var status_message = photon_net_http_client_operation_status_message(
        op, UnsafePointer.address_of(status_message_len)
    )
    assert_true(status_message != c_char_ptr())

    var s_ref = StringRef(status_message, status_message_len)
    assert_true(len(s_ref) > 0)
    assert_true(len(s_ref) == 2)
    assert_equal(s_ref, "OK")
    print("[" + str(s_ref) + "]")

    var s = String(s_ref)
    assert_true(len(s) > 0)
    assert_true(len(s) == 2)
    assert_equal(s, "OK")

    var buf_size = 1024 * 100 * 100
    var buf = UnsafePointer[Int8].alloc(buf_size)
    var read_ret = photon_net_http_client_operation_read(op, buf, buf_size)
    assert_true(read_ret > 0)

    var s_read_ref = StringRef(buf.bitcast[UInt8](), read_ret)
    # var s_read = String(buf.bitcast[UInt8](), read_ret + 1)
    var s_read = String(s_read_ref)
    assert_true(len(s_read) > 0)
    # print("[" + s_read + "]")

    assert_true(s_read.startswith("<!DOCTYPE html"))
    # assert_true(s_read.endswith("</html>"))

    # with open("test_photon_http_client.html", "w") as f:
    #     f.write(s_read)

    buf.free()

    photon_net_http_client_operation_destroy(http_client, op)

    photon_net_http_client_destroy(http_client)

    photon_net_tls_context_destory(tls_context)

    photon_fini()

    print("test_photon_http_client done")
