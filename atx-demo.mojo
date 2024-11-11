import time
from testing import assert_equal, assert_true
from os import getenv
from time import now
from random import randn_float64, random_float64, random_si64, random_ui64, seed
# from atxs import *
# from atxs.httpclient import HttpClient, TlsContext, HttpClientOperation
from atxs_classic import *
from atxs_classic.httpclient_ex import HttpClientEx, TlsContext, HttpClientOperation


fn init_photon() raises -> None:
    var wsl_distro_name = getenv("WSL_DISTRO_NAME")
    var options = PhotonOptions()
    var event_engine = INIT_EVENT_IOURING if wsl_distro_name == "" else INIT_EVENT_EPOLL
    var ret = photon_init(event_engine, INIT_IO_NONE, options)
    assert_equal(ret, 0)


fn fini_photon() raises -> None:
    photon_fini()


fn test_photon_init() raises -> None:
    var wsl_distro_name = getenv("WSL_DISTRO_NAME")
    # assert_true(wsl_distro_name != "")
    # assert_equal(wsl_distro_name, "Ubuntu-22.04")

    var options = PhotonOptions()
    var event_engine = INIT_EVENT_IOURING if wsl_distro_name == "" else INIT_EVENT_EPOLL
    print(event_engine)
    var ret = photon_init(event_engine, INIT_IO_NONE, options)
    assert_equal(ret, 0)

    photon_fini()


fn test_photon_http_client() raises -> None:
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

    print("test_photon_http_client done")


fn test_http_client() raises -> None:
    var http_client = HttpClientEx()

    var user_agent = String(
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML,"
        " like Gecko) Chrome/58.0.3029.110 Safari/537.3"
    )
    http_client.set_user_agent(user_agent)
    var timeout = 1000 * 10
    http_client.set_timeout_ms(timeout)

    var verb = Verb.GET
    var url = String("https://www.baidu.com")
    var op = HttpClientOperation(http_client, verb, url, 1024)
    _ = op.call()
    var status_code = op.status_code()
    assert_equal(status_code, 200)
    var status_message = op.status_message()
    assert_true(len(status_message) > 0)
    assert_true(status_message.startswith("OK"))
    # print("[" + str(status_message) + "]")
    var s_read = op.read_all()
    assert_true(len(s_read) > 0)
    assert_true(s_read.startswith("<!DOCTYPE html"))
    print("len(s_read): " + str(len(s_read)))
    # print("OK-")
    # assert_true(s_read.endswith("</html>"))


fn test_photon_malloc() raises -> None:
    var ptr = photon_malloc(1024)
    assert_true(ptr != c_nullptr)
    photon_free(ptr)


fn test_photon_new_string() raises -> None:
    var size = 1024
    var ptr = photon_new_string(size)
    assert_true(ptr != c_char_ptr())
    photon_free_string(ptr)


fn test_photon_pooled_allocator() raises -> None:
    var allocator = photon_pooled_allocator_new()
    assert_true(allocator != c_void_ptr())
    var io_alloc = photon_pooled_allocator_new_io_alloc(allocator)
    assert_true(io_alloc != c_void_ptr())
    var ptr = photon_io_alloc_alloc(io_alloc, 1024)
    assert_true(ptr != c_void_ptr())
    photon_io_alloc_dealloc(io_alloc, ptr)
    photon_pooled_allocator_destory(allocator)


fn test_mojo_malloc_performance() raises -> None:
    var size = 64 * 1000 * 1000  # 64 MB
    var null_ptr = UnsafePointer[Int8]()
    var start = now()
    var n = 1000000
    var total_sum: Int = 0  # 用于防止优化

    for i in range(n):
        var ptr = UnsafePointer[Int8].alloc(size)
        assert_true(ptr != null_ptr)
        var random_value = random_ui64(0, 255)
        ptr[0] = int(random_value)

        # 进行一些计算，确保 ptr 不会被优化掉
        if ptr != null_ptr:
            total_sum += 1  # 读取内存内容

        ptr.free()

    var end = now()
    print("test_mojo_malloc_performance Time: ", (end - start) / n, "ns")

    print("total_sum: ", total_sum)


fn test_mojo_malloc() raises -> None:
    var size = 64 * 1000 * 1000 * 1000
    var null_ptr = UnsafePointer[Int8]()
    var start = now()
    var n = 1000000
    for i in range(n):
        var ptr = UnsafePointer[Int8].alloc(size)
        assert_true(ptr != null_ptr)
        ptr.free()
    var end = now()
    print("mojo_malloc Time: ", (end - start) / n, "ns")


fn test_malloc_performance() raises -> None:
    var size = 64
    var null_ptr = c_void_ptr()
    var start = now()
    var n = 1000000
    for i in range(n):
        var ptr = photon_malloc(size)
        assert_true(ptr != null_ptr)
        photon_free(ptr)
    var end = now()
    print("malloc Time: ", (end - start) / n, "ns")


fn test_pooled_allocator_performance() raises -> None:
    var size = 64
    var allocator = photon_pooled_allocator_new()
    assert_true(allocator != c_void_ptr())
    var io_alloc = photon_pooled_allocator_new_io_alloc(allocator)
    assert_true(io_alloc != c_void_ptr())

    var null_ptr = c_void_ptr()
    var start = now()
    var n = 1000000
    for i in range(n):
        var ptr = photon_io_alloc_alloc(io_alloc, size)
        assert_true(ptr != null_ptr)
        photon_io_alloc_dealloc(io_alloc, ptr)
    var end = now()
    print("pooled_allocator Time: ", (end - start) / n, "ns")

    photon_pooled_allocator_destory(allocator)


# fn test_httpclient_classic() raises:
#     # var base_url = "https://www.baidu.com"
#     var base_url = "https://api.bybit.com"
#     # https://api.bybit.com/v3/public/time
#     var client = HttpClientClassic(base_url)
#     var headers = Headers()
#     headers["a"] = "abc"
#     var response = client.get("/v3/public/time", headers)
#     print(response.text)

# cp ~/f0cii/echo-cpp2/build/linux/x86_64/release/libecho2.so ~/mojo/echo/
# export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(realpath .)
# export LD_PRELOAD=./libecho2.so
# mojo test test_echo2.mojo


fn main() raises -> None:
    init_photon()
    # test_photon_init()
    # test_photon_http_client()
    test_http_client()
    test_photon_malloc()
    test_photon_new_string()
    test_photon_pooled_allocator()
    test_mojo_malloc_performance()
    test_mojo_malloc()
    test_malloc_performance()
    test_pooled_allocator_performance()
    fini_photon()

    # _ = seq_ct_init()
    # test_httpclient_classic()

    # while True:
    #     time.sleep(1000)
    # export LD_LIBRARY_PATH=/usr/lib:$LD_LIBRARY_PATH:$(realpath .magic/envs/default/lib)
    # export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(realpath /usr/lib .magic/envs/default/lib)
