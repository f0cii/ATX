from collections import Dict
from collections.optional import Optional
from .c import *
from .ssmap import SSMap
from .log import *


alias VERB_UNKNOWN = 0
alias VERB_DELETE = 1
alias VERB_GET = 2
alias VERB_HEAD = 3
alias VERB_POST = 4
alias VERB_PUT = 5


# alias Headers = Dict[String, String]
alias Headers = SSMap
alias DEFAULT_BUFF_SIZE = 1024 * 100

alias tlsv12 = 15
alias tlsv12_client = 16
alias tlsv13 = 18
alias tlsv13_client = 19


@value
struct QueryParams:
    var data: Dict[String, String]

    fn __init__(inout self):
        self.data = Dict[String, String]()

    fn __setitem__(inout self, name: String, value: String):
        self.data[name] = value

    fn to_string(self) raises -> String:
        if len(self.data) == 0:
            return ""

        var url = String("?")
        for item in self.data.items():
            # if item.value == "":
            #     continue
            url += item[].key + "=" + item[].value + "&"
        return url[1:-1]

    fn debug(inout self) raises:
        for item in self.data.items():
            logi(
                # str(i)
                # + ": "
                str(item[].key)
                + " = "
                + str(item[].value)
            )


@value
struct HttpResponse:
    var status_code: Int
    var text: String

    fn __init__(inout self, status_code: Int, text: String):
        self.status_code = status_code
        self.text = text


struct HttpClient:
    var _base_url: String
    var _method: Int
    var ptr: c_void_ptr
    var _verbose: Bool

    fn __init__(inout self, base_url: String, method: Int = tlsv12_client):
        logd("HttpClient.__init__")
        self._base_url = base_url
        self._method = method
        self.ptr = seq_cclient_new(
            self._base_url.unsafe_cstr_ptr(),
            len(self._base_url),
            method,
        )
        self._verbose = False
        logd("HttpClient.__init__ done")

    fn __moveinit__(inout self, owned existing: Self):
        logd("HttpClient.__moveinit__")
        self._base_url = existing._base_url
        self._method = existing._method
        self.ptr = seq_cclient_new(
            self._base_url.unsafe_cstr_ptr(),
            len(self._base_url),
            self._method,
        )
        self._verbose = existing._verbose
        existing.ptr = c_void_ptr()
        logd("HttpClient.__moveinit__ done")

    fn __del__(owned self):
        logd("HttpClient.__del__")
        var NULL = c_void_ptr()
        if self.ptr != NULL:
            seq_cclient_free(self.ptr)
            self.ptr = NULL
        logd("HttpClient.__del__ done")

    fn set_verbose(inout self, verbose: Bool):
        self._verbose = verbose

    fn delete(
        self,
        path: String,
        inout headers: Headers,
        buffer_size: Int = DEFAULT_BUFF_SIZE,
    ) -> HttpResponse:
        var response = self.do_request(
            path, VERB_DELETE, headers, "", buffer_size
        )
        return response

    fn get(
        self,
        path: String,
        inout headers: Headers,
        buffer_size: Int = DEFAULT_BUFF_SIZE,
    ) -> HttpResponse:
        var response = self.do_request(path, VERB_GET, headers, "", buffer_size)
        return response

    fn head(
        self,
        path: String,
        payload: String,
        inout headers: Headers,
        buffer_size: Int = DEFAULT_BUFF_SIZE,
    ) -> HttpResponse:
        var response = self.do_request(
            path, VERB_HEAD, headers, payload, buffer_size
        )
        return response

    fn post(
        self,
        path: String,
        payload: String,
        inout headers: Headers,
        buffer_size: Int = DEFAULT_BUFF_SIZE,
    ) -> HttpResponse:
        var response = self.do_request(
            path, VERB_POST, headers, payload, buffer_size
        )
        return response

    fn put(
        self,
        path: String,
        payload: String,
        inout headers: Headers,
        buffer_size: Int = DEFAULT_BUFF_SIZE,
    ) -> HttpResponse:
        var response = self.do_request(
            path, VERB_PUT, headers, payload, buffer_size
        )
        return response

    fn do_request(
        self,
        path: String,
        verb: Int,
        inout headers: Headers,
        payload: String,
        buffer_size: Int,
    ) -> HttpResponse:
        var n: Int = 0
        headers["user-agent"] = "ECHO/1.0.0"
        var buff = UnsafePointer[UInt8].alloc(buffer_size)
        var status = seq_cclient_do_request(
            self.ptr,
            path.unsafe_cstr_ptr(),
            len(path),
            verb,
            headers.ptr,
            payload.unsafe_cstr_ptr(),
            len(payload),
            buff,
            buffer_size,
            UnsafePointer[Int].address_of(n),
            self._verbose,
        )

        var s = c_str_to_string(buff, n)
        buff.free()

        return HttpResponse(status, s)
