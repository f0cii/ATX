from sys import external_call
from sys.ffi import DLHandle


var __wrapper = _DLWrapper()


@value
struct _DLWrapper:
    var _handle: DLHandle

    var _seq_simdjson_dom_parser_new: DL_Fn[
        "seq_simdjson_dom_parser_new", fn (max_capacity: Int) -> c_void_ptr
    ]

    var _seq_simdjson_dom_parser_free: DL_Fn[
        "seq_simdjson_dom_parser_free", fn (parser: c_void_ptr) -> None
    ]

    var _seq_simdjson_dom_parser_parse: DL_Fn[
        "seq_simdjson_dom_parser_parse",
        fn (parser: c_void_ptr, s: c_char_ptr, len: c_size_t) -> c_void_ptr,
    ]

    var _seq_simdjson_dom_element_is_valid: DL_Fn[
        "seq_simdjson_dom_element_is_valid", fn (p: c_void_ptr) -> Bool
    ]

    var _seq_simdjson_dom_element_free: DL_Fn[
        "seq_simdjson_dom_element_free", fn (p: c_void_ptr) -> None
    ]

    var _seq_simdjson_dom_document_get_element: DL_Fn[
        "seq_simdjson_dom_document_get_element",
        fn (document: c_void_ptr, key: c_char_ptr, len: c_size_t) -> c_void_ptr,
    ]

    var _seq_simdjson_dom_element_get_int: DL_Fn[
        "seq_simdjson_dom_element_get_int",
        fn (p: c_void_ptr, key: c_char_ptr, len: c_size_t) -> Int,
    ]

    var _seq_simdjson_dom_element_get_uint: DL_Fn[
        "seq_simdjson_dom_element_get_uint",
        fn (p: c_void_ptr, key: c_char_ptr, len: c_size_t) -> Int,
    ]

    var _seq_simdjson_dom_element_get_float: DL_Fn[
        "seq_simdjson_dom_element_get_float",
        fn (p: c_void_ptr, key: c_char_ptr, len: c_size_t) -> Float64,
    ]

    var _seq_simdjson_dom_element_get_bool: DL_Fn[
        "seq_simdjson_dom_element_get_bool",
        fn (p: c_void_ptr, key: c_char_ptr, len: c_size_t) -> Bool,
    ]

    var _seq_simdjson_dom_object_get_int: DL_Fn[
        "seq_simdjson_dom_object_get_int",
        fn (dom: c_void_ptr, key: c_char_ptr, len: c_size_t) -> Int,
    ]

    var _seq_simdjson_dom_object_get_uint: DL_Fn[
        "seq_simdjson_dom_object_get_uint",
        fn (dom: c_void_ptr, key: c_char_ptr, len: c_size_t) -> Int,
    ]

    var _seq_simdjson_dom_object_get_float: DL_Fn[
        "seq_simdjson_dom_object_get_float",
        fn (dom: c_void_ptr, key: c_char_ptr, len: c_size_t) -> Float64,
    ]

    var _seq_simdjson_dom_object_get_bool: DL_Fn[
        "seq_simdjson_dom_object_get_bool",
        fn (dom: c_void_ptr, key: c_char_ptr, len: c_size_t) -> Bool,
    ]

    var _seq_simdjson_dom_element_get_object: DL_Fn[
        "seq_simdjson_dom_element_get_object",
        fn (element: c_void_ptr, key: c_char_ptr, len: c_size_t) -> c_void_ptr,
    ]

    var _seq_simdjson_dom_element_get_array: DL_Fn[
        "seq_simdjson_dom_element_get_array",
        fn (element: c_void_ptr, key: c_char_ptr, len: c_size_t) -> c_void_ptr,
    ]

    var _seq_simdjson_dom_object_get_object: DL_Fn[
        "seq_simdjson_dom_object_get_object",
        fn (obj: c_void_ptr, key: c_char_ptr, len: c_size_t) -> c_void_ptr,
    ]

    var _seq_simdjson_dom_object_get_array: DL_Fn[
        "seq_simdjson_dom_object_get_array",
        fn (obj: c_void_ptr, key: c_char_ptr, len: c_size_t) -> c_void_ptr,
    ]

    var _seq_simdjson_dom_element_int: DL_Fn[
        "seq_simdjson_dom_element_int", fn (p: c_void_ptr) -> Int
    ]

    var _seq_simdjson_dom_element_uint: DL_Fn[
        "seq_simdjson_dom_element_uint", fn (p: c_void_ptr) -> Int
    ]

    var _seq_simdjson_dom_element_float: DL_Fn[
        "seq_simdjson_dom_element_float", fn (p: c_void_ptr) -> Float64
    ]

    var _seq_simdjson_dom_element_bool: DL_Fn[
        "seq_simdjson_dom_element_bool", fn (p: c_void_ptr) -> Bool
    ]

    var _seq_simdjson_dom_object_free: DL_Fn[
        "seq_simdjson_dom_object_free", fn (p: c_void_ptr) -> None
    ]

    var _seq_simdjson_dom_array_free: DL_Fn[
        "seq_simdjson_dom_array_free", fn (p: c_void_ptr) -> None
    ]

    var _seq_simdjson_dom_array_iter_free: DL_Fn[
        "seq_simdjson_dom_array_iter_free", fn (p: c_void_ptr) -> None
    ]

    var _seq_simdjson_dom_element_str: DL_Fn[
        "seq_simdjson_dom_element_str",
        fn (p: c_void_ptr, n: UnsafePointer[c_size_t]) -> c_void_ptr,
    ]

    var _seq_simdjson_dom_element_type: DL_Fn[
        "seq_simdjson_dom_element_type", fn (p: c_void_ptr) -> Int
    ]

    var _seq_simdjson_dom_element_object: DL_Fn[
        "seq_simdjson_dom_element_object", fn (p: c_void_ptr) -> c_void_ptr
    ]

    var _seq_simdjson_dom_element_array: DL_Fn[
        "seq_simdjson_dom_element_array", fn (p: c_void_ptr) -> c_void_ptr
    ]

    var _seq_simdjson_dom_element_get_str: DL_Fn[
        "seq_simdjson_dom_element_get_str",
        fn (
            p: c_void_ptr,
            key: c_char_ptr,
            len: c_size_t,
            n: UnsafePointer[c_size_t],
        ) -> c_char_ptr,
    ]

    var _seq_simdjson_dom_object_get_str: DL_Fn[
        "seq_simdjson_dom_object_get_str",
        fn (
            p: c_void_ptr,
            key: c_char_ptr,
            len: c_size_t,
            n: UnsafePointer[c_size_t],
        ) -> c_char_ptr,
    ]

    var _seq_simdjson_dom_array_begin: DL_Fn[
        "seq_simdjson_dom_array_begin", fn (p: c_void_ptr) -> c_void_ptr
    ]

    var _seq_simdjson_dom_array_end: DL_Fn[
        "seq_simdjson_dom_array_end", fn (p: c_void_ptr) -> c_void_ptr
    ]

    var _seq_simdjson_dom_array_size: DL_Fn[
        "seq_simdjson_dom_array_size", fn (p: c_void_ptr) -> Int
    ]

    var _seq_simdjson_dom_array_number_of_slots: DL_Fn[
        "seq_simdjson_dom_array_number_of_slots", fn (p: c_void_ptr) -> Int
    ]

    var _seq_simdjson_dom_array_at: DL_Fn[
        "seq_simdjson_dom_array_at",
        fn (p: c_void_ptr, index: c_size_t) -> c_void_ptr,
    ]

    var _seq_simdjson_dom_array_at_int: DL_Fn[
        "seq_simdjson_dom_array_at_int",
        fn (p: c_void_ptr, index: c_size_t) -> Int,
    ]

    var _seq_simdjson_dom_array_at_uint: DL_Fn[
        "seq_simdjson_dom_array_at_uint",
        fn (p: c_void_ptr, index: c_size_t) -> Int,
    ]

    var _seq_simdjson_dom_array_at_float: DL_Fn[
        "seq_simdjson_dom_array_at_float",
        fn (p: c_void_ptr, index: c_size_t) -> Float64,
    ]

    var _seq_simdjson_dom_array_at_bool: DL_Fn[
        "seq_simdjson_dom_array_at_bool",
        fn (p: c_void_ptr, index: c_size_t) -> Bool,
    ]

    var _seq_simdjson_dom_array_at_str: DL_Fn[
        "seq_simdjson_dom_array_at_str",
        fn (
            p: c_void_ptr, index: c_size_t, n: UnsafePointer[c_size_t]
        ) -> c_char_ptr,
    ]

    var _seq_simdjson_dom_array_at_obj: DL_Fn[
        "seq_simdjson_dom_array_at_obj",
        fn (p: c_void_ptr, index: c_size_t) -> c_void_ptr,
    ]

    var _seq_simdjson_dom_array_at_arr: DL_Fn[
        "seq_simdjson_dom_array_at_arr",
        fn (p: c_void_ptr, index: c_size_t) -> c_void_ptr,
    ]

    var _seq_simdjson_dom_array_at_pointer: DL_Fn[
        "seq_simdjson_dom_array_at_pointer",
        fn (p: c_void_ptr, key: c_char_ptr, len: c_size_t) -> c_void_ptr,
    ]

    var _seq_simdjson_dom_array_iter_get: DL_Fn[
        "seq_simdjson_dom_array_iter_get", fn (it: c_void_ptr) -> c_void_ptr
    ]

    var _seq_simdjson_dom_array_iter_get_int: DL_Fn[
        "seq_simdjson_dom_array_iter_get_int", fn (it: c_void_ptr) -> Int
    ]

    var _seq_simdjson_dom_array_iter_get_uint: DL_Fn[
        "seq_simdjson_dom_array_iter_get_uint", fn (it: c_void_ptr) -> Int
    ]

    var _seq_simdjson_dom_array_iter_get_float: DL_Fn[
        "seq_simdjson_dom_array_iter_get_float", fn (it: c_void_ptr) -> Float64
    ]

    var _seq_simdjson_dom_array_iter_get_bool: DL_Fn[
        "seq_simdjson_dom_array_iter_get_bool", fn (it: c_void_ptr) -> Bool
    ]

    var _seq_simdjson_dom_array_iter_get_str: DL_Fn[
        "seq_simdjson_dom_array_iter_get_str",
        fn (it: c_void_ptr, n: UnsafePointer[c_size_t]) -> c_void_ptr,
    ]

    var _seq_simdjson_dom_array_iter_get_obj: DL_Fn[
        "seq_simdjson_dom_array_iter_get_obj", fn (it: c_void_ptr) -> c_void_ptr
    ]

    var _seq_simdjson_dom_array_iter_get_arr: DL_Fn[
        "seq_simdjson_dom_array_iter_get_arr", fn (it: c_void_ptr) -> c_void_ptr
    ]

    var _seq_simdjson_dom_array_iter_not_equal: DL_Fn[
        "seq_simdjson_dom_array_iter_not_equal",
        fn (lhs: c_void_ptr, rhs: c_void_ptr) -> Bool,
    ]

    var _seq_simdjson_dom_array_iter_step: DL_Fn[
        "seq_simdjson_dom_array_iter_step", fn (it: c_void_ptr) -> None
    ]

    fn __init__(out self):
        self._handle = DLHandle(LIBNAME)

        self._seq_simdjson_dom_parser_new = self._handle
        self._seq_simdjson_dom_parser_free = self._handle
        self._seq_simdjson_dom_parser_parse = self._handle
        self._seq_simdjson_dom_element_is_valid = self._handle
        self._seq_simdjson_dom_element_free = self._handle
        self._seq_simdjson_dom_document_get_element = self._handle
        self._seq_simdjson_dom_element_get_int = self._handle
        self._seq_simdjson_dom_element_get_uint = self._handle
        self._seq_simdjson_dom_element_get_float = self._handle
        self._seq_simdjson_dom_element_get_bool = self._handle
        self._seq_simdjson_dom_object_get_int = self._handle
        self._seq_simdjson_dom_object_get_uint = self._handle
        self._seq_simdjson_dom_object_get_float = self._handle
        self._seq_simdjson_dom_object_get_bool = self._handle
        self._seq_simdjson_dom_element_get_object = self._handle
        self._seq_simdjson_dom_element_get_array = self._handle
        self._seq_simdjson_dom_object_get_object = self._handle
        self._seq_simdjson_dom_object_get_array = self._handle
        self._seq_simdjson_dom_element_int = self._handle
        self._seq_simdjson_dom_element_uint = self._handle
        self._seq_simdjson_dom_element_float = self._handle
        self._seq_simdjson_dom_element_bool = self._handle
        self._seq_simdjson_dom_object_free = self._handle
        self._seq_simdjson_dom_array_free = self._handle
        self._seq_simdjson_dom_array_iter_free = self._handle
        self._seq_simdjson_dom_element_str = self._handle
        self._seq_simdjson_dom_element_type = self._handle
        self._seq_simdjson_dom_element_object = self._handle
        self._seq_simdjson_dom_element_array = self._handle
        self._seq_simdjson_dom_element_get_str = self._handle
        self._seq_simdjson_dom_object_get_str = self._handle
        self._seq_simdjson_dom_array_begin = self._handle
        self._seq_simdjson_dom_array_end = self._handle
        self._seq_simdjson_dom_array_size = self._handle
        self._seq_simdjson_dom_array_number_of_slots = self._handle
        self._seq_simdjson_dom_array_at = self._handle
        self._seq_simdjson_dom_array_at_int = self._handle
        self._seq_simdjson_dom_array_at_uint = self._handle
        self._seq_simdjson_dom_array_at_float = self._handle
        self._seq_simdjson_dom_array_at_bool = self._handle
        self._seq_simdjson_dom_array_at_str = self._handle
        self._seq_simdjson_dom_array_at_obj = self._handle
        self._seq_simdjson_dom_array_at_arr = self._handle
        self._seq_simdjson_dom_array_at_pointer = self._handle
        self._seq_simdjson_dom_array_iter_get = self._handle
        self._seq_simdjson_dom_array_iter_get_int = self._handle
        self._seq_simdjson_dom_array_iter_get_uint = self._handle
        self._seq_simdjson_dom_array_iter_get_float = self._handle
        self._seq_simdjson_dom_array_iter_get_bool = self._handle
        self._seq_simdjson_dom_array_iter_get_str = self._handle
        self._seq_simdjson_dom_array_iter_get_obj = self._handle
        self._seq_simdjson_dom_array_iter_get_arr = self._handle
        self._seq_simdjson_dom_array_iter_not_equal = self._handle
        self._seq_simdjson_dom_array_iter_step = self._handle


@always_inline
fn seq_simdjson_dom_parser_new(max_capacity: Int) -> c_void_ptr:
    return __wrapper._seq_simdjson_dom_parser_new.call(max_capacity)


@always_inline
fn seq_simdjson_dom_parser_free(parser: c_void_ptr) -> None:
    return __wrapper._seq_simdjson_dom_parser_free.call(parser)


@always_inline
fn seq_simdjson_dom_parser_parse(
    parser: c_void_ptr, s: c_char_ptr, len: c_size_t
) -> c_void_ptr:
    return __wrapper._seq_simdjson_dom_parser_parse.call(parser, s, len)


@always_inline
fn seq_simdjson_dom_element_is_valid(p: c_void_ptr) -> Bool:
    return __wrapper._seq_simdjson_dom_element_is_valid.call(p)


@always_inline
fn seq_simdjson_dom_element_free(p: c_void_ptr) -> None:
    return __wrapper._seq_simdjson_dom_element_free.call(p)


@always_inline
fn seq_simdjson_dom_document_get_element(
    document: c_void_ptr, key: c_char_ptr, len: c_size_t
) -> c_void_ptr:
    return __wrapper._seq_simdjson_dom_document_get_element.call(
        document, key, len
    )


@always_inline
fn seq_simdjson_dom_element_get_int(
    p: c_void_ptr, key: c_char_ptr, len: c_size_t
) -> Int:
    return __wrapper._seq_simdjson_dom_element_get_int.call(p, key, len)


@always_inline
fn seq_simdjson_dom_element_get_uint(
    p: c_void_ptr, key: c_char_ptr, len: c_size_t
) -> Int:
    return __wrapper._seq_simdjson_dom_element_get_uint.call(p, key, len)


@always_inline
fn seq_simdjson_dom_element_get_float(
    p: c_void_ptr, key: c_char_ptr, len: c_size_t
) -> Float64:
    return __wrapper._seq_simdjson_dom_element_get_float.call(p, key, len)


@always_inline
fn seq_simdjson_dom_element_get_bool(
    p: c_void_ptr, key: c_char_ptr, len: c_size_t
) -> Bool:
    return __wrapper._seq_simdjson_dom_element_get_bool.call(p, key, len)


@always_inline
fn seq_simdjson_dom_object_get_int(
    dom: c_void_ptr, key: c_char_ptr, len: c_size_t
) -> Int:
    return __wrapper._seq_simdjson_dom_object_get_int.call(dom, key, len)


@always_inline
fn seq_simdjson_dom_object_get_uint(
    dom: c_void_ptr, key: c_char_ptr, len: c_size_t
) -> Int:
    return __wrapper._seq_simdjson_dom_object_get_uint.call(dom, key, len)


@always_inline
fn seq_simdjson_dom_object_get_float(
    dom: c_void_ptr, key: c_char_ptr, len: c_size_t
) -> Float64:
    return __wrapper._seq_simdjson_dom_object_get_float.call(dom, key, len)


@always_inline
fn seq_simdjson_dom_object_get_bool(
    dom: c_void_ptr, key: c_char_ptr, len: c_size_t
) -> Bool:
    return __wrapper._seq_simdjson_dom_object_get_bool.call(dom, key, len)


@always_inline
fn seq_simdjson_dom_element_get_object(
    element: c_void_ptr, key: c_char_ptr, len: c_size_t
) -> c_void_ptr:
    return __wrapper._seq_simdjson_dom_element_get_object.call(element, key, len)


@always_inline
fn seq_simdjson_dom_element_get_array(
    element: c_void_ptr, key: c_char_ptr, len: c_size_t
) -> c_void_ptr:
    return __wrapper._seq_simdjson_dom_element_get_array.call(element, key, len)


@always_inline
fn seq_simdjson_dom_object_get_object(
    obj: c_void_ptr, key: c_char_ptr, len: c_size_t
) -> c_void_ptr:
    return __wrapper._seq_simdjson_dom_object_get_object.call(obj, key, len)


@always_inline
fn seq_simdjson_dom_object_get_array(
    obj: c_void_ptr, key: c_char_ptr, len: c_size_t
) -> c_void_ptr:
    return __wrapper._seq_simdjson_dom_object_get_array.call(obj, key, len)


@always_inline
fn seq_simdjson_dom_element_int(p: c_void_ptr) -> Int:
    return __wrapper._seq_simdjson_dom_element_int.call(p)


@always_inline
fn seq_simdjson_dom_element_uint(p: c_void_ptr) -> Int:
    return __wrapper._seq_simdjson_dom_element_uint.call(p)


@always_inline
fn seq_simdjson_dom_element_float(p: c_void_ptr) -> Float64:
    return __wrapper._seq_simdjson_dom_element_float.call(p)


@always_inline
fn seq_simdjson_dom_element_bool(p: c_void_ptr) -> Bool:
    return __wrapper._seq_simdjson_dom_element_bool.call(p)


@always_inline
fn seq_simdjson_dom_object_free(p: c_void_ptr) -> None:
    return __wrapper._seq_simdjson_dom_object_free.call(p)


@always_inline
fn seq_simdjson_dom_array_free(p: c_void_ptr) -> None:
    return __wrapper._seq_simdjson_dom_array_free.call(p)


@always_inline
fn seq_simdjson_dom_array_iter_free(p: c_void_ptr) -> None:
    return __wrapper._seq_simdjson_dom_array_iter_free.call(p)


@always_inline
fn seq_simdjson_dom_element_str(
    p: c_void_ptr, n: UnsafePointer[c_size_t]
) -> c_void_ptr:
    return __wrapper._seq_simdjson_dom_element_str.call(p, n)


@always_inline
fn seq_simdjson_dom_element_type(p: c_void_ptr) -> Int:
    return __wrapper._seq_simdjson_dom_element_type.call(p)


@always_inline
fn seq_simdjson_dom_element_object(p: c_void_ptr) -> c_void_ptr:
    return __wrapper._seq_simdjson_dom_element_object.call(p)


@always_inline
fn seq_simdjson_dom_element_array(p: c_void_ptr) -> c_void_ptr:
    return __wrapper._seq_simdjson_dom_element_array.call(p)


@always_inline
fn seq_simdjson_dom_element_get_str(
    p: c_void_ptr,
    key: c_char_ptr,
    len: c_size_t,
    n: UnsafePointer[c_size_t],
) -> c_char_ptr:
    return __wrapper._seq_simdjson_dom_element_get_str.call(p, key, len, n)


@always_inline
fn seq_simdjson_dom_object_get_str(
    p: c_void_ptr,
    key: c_char_ptr,
    len: c_size_t,
    n: UnsafePointer[c_size_t],
) -> c_char_ptr:
    return __wrapper._seq_simdjson_dom_object_get_str.call(p, key, len, n)


@always_inline
fn seq_simdjson_dom_array_begin(p: c_void_ptr) -> c_void_ptr:
    return __wrapper._seq_simdjson_dom_array_begin.call(p)


@always_inline
fn seq_simdjson_dom_array_end(p: c_void_ptr) -> c_void_ptr:
    return __wrapper._seq_simdjson_dom_array_end.call(p)


@always_inline
fn seq_simdjson_dom_array_size(p: c_void_ptr) -> Int:
    return __wrapper._seq_simdjson_dom_array_size.call(p)


@always_inline
fn seq_simdjson_dom_array_number_of_slots(p: c_void_ptr) -> Int:
    return __wrapper._seq_simdjson_dom_array_number_of_slots.call(p)


@always_inline
fn seq_simdjson_dom_array_at(p: c_void_ptr, index: c_size_t) -> c_void_ptr:
    return __wrapper._seq_simdjson_dom_array_at.call(p, index)


@always_inline
fn seq_simdjson_dom_array_at_int(p: c_void_ptr, index: c_size_t) -> Int:
    return __wrapper._seq_simdjson_dom_array_at_int.call(p, index)


@always_inline
fn seq_simdjson_dom_array_at_uint(p: c_void_ptr, index: c_size_t) -> Int:
    return __wrapper._seq_simdjson_dom_array_at_uint.call(p, index)


@always_inline
fn seq_simdjson_dom_array_at_float(p: c_void_ptr, index: c_size_t) -> Float64:
    return __wrapper._seq_simdjson_dom_array_at_float.call(p, index)


@always_inline
fn seq_simdjson_dom_array_at_bool(p: c_void_ptr, index: c_size_t) -> Bool:
    return __wrapper._seq_simdjson_dom_array_at_bool.call(p, index)


@always_inline
fn seq_simdjson_dom_array_at_str(
    p: c_void_ptr, index: c_size_t, n: UnsafePointer[c_size_t]
) -> c_char_ptr:
    return __wrapper._seq_simdjson_dom_array_at_str.call(p, index, n)


@always_inline
fn seq_simdjson_dom_array_at_obj(p: c_void_ptr, index: c_size_t) -> c_void_ptr:
    return __wrapper._seq_simdjson_dom_array_at_obj.call(p, index)


@always_inline
fn seq_simdjson_dom_array_at_arr(p: c_void_ptr, index: c_size_t) -> c_void_ptr:
    return __wrapper._seq_simdjson_dom_array_at_arr.call(p, index)


@always_inline
fn seq_simdjson_dom_array_at_pointer(
    p: c_void_ptr, key: c_char_ptr, len: c_size_t
) -> c_void_ptr:
    return __wrapper._seq_simdjson_dom_array_at_pointer.call(p, key, len)


@always_inline
fn seq_simdjson_dom_array_iter_get(it: c_void_ptr) -> c_void_ptr:
    return __wrapper._seq_simdjson_dom_array_iter_get.call(it)


@always_inline
fn seq_simdjson_dom_array_iter_get_int(it: c_void_ptr) -> Int:
    return __wrapper._seq_simdjson_dom_array_iter_get_int.call(it)


@always_inline
fn seq_simdjson_dom_array_iter_get_uint(it: c_void_ptr) -> Int:
    return __wrapper._seq_simdjson_dom_array_iter_get_uint.call(it)


@always_inline
fn seq_simdjson_dom_array_iter_get_float(it: c_void_ptr) -> Float64:
    return __wrapper._seq_simdjson_dom_array_iter_get_float.call(it)


@always_inline
fn seq_simdjson_dom_array_iter_get_bool(it: c_void_ptr) -> Bool:
    return __wrapper._seq_simdjson_dom_array_iter_get_bool.call(it)


@always_inline
fn seq_simdjson_dom_array_iter_get_str(
    it: c_void_ptr, n: UnsafePointer[c_size_t]
) -> c_void_ptr:
    return __wrapper._seq_simdjson_dom_array_iter_get_str.call(it, n)


@always_inline
fn seq_simdjson_dom_array_iter_get_obj(it: c_void_ptr) -> c_void_ptr:
    return __wrapper._seq_simdjson_dom_array_iter_get_obj.call(it)


@always_inline
fn seq_simdjson_dom_array_iter_get_arr(it: c_void_ptr) -> c_void_ptr:
    return __wrapper._seq_simdjson_dom_array_iter_get_arr.call(it)


@always_inline
fn seq_simdjson_dom_array_iter_not_equal(
    lhs: c_void_ptr, rhs: c_void_ptr
) -> Bool:
    return __wrapper._seq_simdjson_dom_array_iter_not_equal.call(lhs, rhs)


@always_inline
fn seq_simdjson_dom_array_iter_step(it: c_void_ptr) -> None:
    return __wrapper._seq_simdjson_dom_array_iter_step.call(it)


@value
struct DomElement:
    var p: c_void_ptr

    @always_inline
    fn __init__(out self, p: c_void_ptr):
        self.p = p

    @always_inline
    fn __del__(owned self):
        # logd("DomElement.__del__")
        seq_simdjson_dom_element_free(self.p)
        # logd("DomElement.__del__ done")

    @always_inline
    fn __getitem__(self, key: StringLiteral) -> DomElement:
        var elem = seq_simdjson_dom_document_get_element(
            self.p, key.unsafe_cstr_ptr(), len(key)
        )
        return DomElement(elem)

    @always_inline
    fn get_int(self, key: StringLiteral) -> Int:
        return seq_simdjson_dom_element_get_int(
            self.p, key.unsafe_cstr_ptr(), len(key)
        )

    @always_inline
    fn get_uint(self, key: StringLiteral) -> Int:
        return seq_simdjson_dom_element_get_uint(
            self.p, key.unsafe_cstr_ptr(), len(key)
        )

    @always_inline
    fn get_float(self, key: StringLiteral) -> Float64:
        return seq_simdjson_dom_element_get_float(
            self.p, key.unsafe_cstr_ptr(), len(key)
        )

    @always_inline
    fn get_bool(self, key: StringLiteral) -> Bool:
        return seq_simdjson_dom_element_get_bool(
            self.p, key.unsafe_cstr_ptr(), len(key)
        )

    @always_inline
    fn get_str(self, key: StringLiteral) -> String:
        var n: c_size_t = 0
        var s = seq_simdjson_dom_element_get_str(
            self.p,
            key.unsafe_cstr_ptr(),
            len(key),
            UnsafePointer[c_size_t].address_of(n),
        )
        return c_str_to_string(s, n)

    @always_inline
    fn get_object(self, key: StringLiteral) -> DomObject:
        var p = seq_simdjson_dom_element_get_object(
            self.p, key.unsafe_cstr_ptr(), len(key)
        )
        return DomObject(p)

    @always_inline
    fn get_array(self, key: StringLiteral) -> DomArray:
        var p = seq_simdjson_dom_element_get_array(
            self.p, key.unsafe_cstr_ptr(), len(key)
        )
        return DomArray(p)

    @always_inline
    fn type(self) -> Int:
        return seq_simdjson_dom_element_type(self.p)

    @always_inline
    fn type_desc(self) -> String:
        var type_ = seq_simdjson_dom_element_type(self.p)
        if type_ == 0:
            return "array"
        elif type_ == 1:
            return "object"
        elif type_ == 2:
            return "int64_t"
        elif type_ == 3:
            return "uint64_t"
        elif type_ == 4:
            return "double"
        elif type_ == 5:
            return "string"
        elif type_ == 6:
            return "bool"
        elif type_ == 7:
            return "null"
        elif type_ == 9:
            return "unexpected content!!!"
        else:
            return "--"

    @always_inline
    fn object(self) -> DomObject:
        var p = seq_simdjson_dom_element_object(self.p)
        return DomObject(p)

    @always_inline
    fn array(self) -> DomArray:
        var p = seq_simdjson_dom_element_array(self.p)
        return DomArray(p)

    @always_inline
    fn int(self) -> Int:
        return seq_simdjson_dom_element_int(self.p)

    @always_inline
    fn uint(self) -> Int:
        return seq_simdjson_dom_element_uint(self.p)

    @always_inline
    fn float(self) -> Float64:
        return seq_simdjson_dom_element_float(self.p)

    @always_inline
    fn bool(self) -> Bool:
        return seq_simdjson_dom_element_bool(self.p)

    @always_inline
    fn str(self) -> String:
        var n: c_size_t = 0
        var s = seq_simdjson_dom_element_str(
            self.p, UnsafePointer[c_size_t].address_of(n)
        )
        return c_str_to_string(s, n)

    fn __repr__(self) -> String:
        return "<DomElement: p={self.p}>"


@value
struct DomObject(CollectionElement):
    var p: c_void_ptr

    @always_inline
    fn __init__(out self, p: c_void_ptr):
        self.p = p

    @always_inline
    fn __del__(owned self):
        # logd("DomObject.__del__")
        seq_simdjson_dom_object_free(self.p)
        # logd("DomObject.__del__ done")

    @always_inline
    fn get_int(self, key: StringLiteral) -> Int:
        return seq_simdjson_dom_object_get_int(
            self.p, key.unsafe_cstr_ptr(), len(key)
        )

    @always_inline
    fn get_uint(self, key: StringLiteral) -> Int:
        return seq_simdjson_dom_object_get_uint(
            self.p, key.unsafe_cstr_ptr(), len(key)
        )

    @always_inline
    fn get_float(self, key: StringLiteral) -> Float64:
        return seq_simdjson_dom_object_get_float(
            self.p, key.unsafe_cstr_ptr(), len(key)
        )

    @always_inline
    fn get_bool(self, key: StringLiteral) -> Bool:
        return seq_simdjson_dom_object_get_bool(
            self.p, key.unsafe_cstr_ptr(), len(key)
        )

    @always_inline
    fn get_str(self, key: StringLiteral) -> String:
        var n: c_size_t = 0
        var s = seq_simdjson_dom_object_get_str(
            self.p,
            key.unsafe_cstr_ptr(),
            len(key),
            UnsafePointer[c_size_t].address_of(n),
        )
        return c_str_to_string(s, n)

    @always_inline
    fn get_object(self, key: StringLiteral) -> DomObject:
        var p = seq_simdjson_dom_object_get_object(
            self.p, key.unsafe_cstr_ptr(), len(key)
        )
        return DomObject(p)

    @always_inline
    fn get_array(self, key: StringLiteral) -> DomArray:
        var p = seq_simdjson_dom_object_get_array(
            self.p, key.unsafe_cstr_ptr(), len(key)
        )
        return DomArray(p)

    fn __repr__(self) -> String:
        return "<DomObject: p={self.p}>"


@value
struct DomArray:
    var p: c_void_ptr

    @always_inline
    fn __init__(out self, p: c_void_ptr):
        self.p = p

    @always_inline
    fn __del__(owned self):
        # logd("DomArray.__del__")
        seq_simdjson_dom_array_free(self.p)
        # logd("DomArray.__del__ done")

    @always_inline
    fn __len__(self) -> Int:
        return seq_simdjson_dom_array_size(self.p)

    @always_inline
    fn number_of_slots(self) -> Int:
        return seq_simdjson_dom_array_number_of_slots(self.p)

    @always_inline
    fn at(self, index: Int) -> DomElement:
        var p = seq_simdjson_dom_array_at(self.p, index)
        return DomElement(p)

    @always_inline
    fn at_int(self, index: Int) -> Int:
        return seq_simdjson_dom_array_at_int(self.p, index)

    @always_inline
    fn at_uint(self, index: Int) -> Int:
        return seq_simdjson_dom_array_at_uint(self.p, index)

    @always_inline
    fn at_float(self, index: Int) -> Float64:
        return seq_simdjson_dom_array_at_float(self.p, index)

    @always_inline
    fn at_bool(self, index: Int) -> Bool:
        return seq_simdjson_dom_array_at_bool(self.p, index)

    @always_inline
    fn at_str(self, index: Int) -> String:
        var n: c_size_t = 0
        var s = seq_simdjson_dom_array_at_str(
            self.p, index, UnsafePointer[c_size_t].address_of(n)
        )
        return c_str_to_string(s, n)

    @always_inline
    fn at_obj(self, index: Int) -> DomObject:
        var p = seq_simdjson_dom_array_at_obj(self.p, index)
        return DomObject(p)

    @always_inline
    fn at_arr(self, index: Int) -> DomArray:
        var p = seq_simdjson_dom_array_at_arr(self.p, index)
        return DomArray(p)

    @always_inline
    fn iter(self) -> DomArrayIter:
        return DomArrayIter(self.p)

    fn __repr__(self) -> String:
        return "<DomArray: p={self.p}>"


@value
struct DomArrayIter:
    var arr: c_void_ptr
    var it: c_void_ptr
    var end: c_void_ptr

    @always_inline
    fn __init__(out self, arr: c_void_ptr):
        self.arr = arr
        self.it = seq_simdjson_dom_array_begin(arr)
        self.end = seq_simdjson_dom_array_end(arr)

    @always_inline
    fn __del__(owned self):
        # logd("DomArrayIter.__del__")
        seq_simdjson_dom_array_iter_free(self.it)
        seq_simdjson_dom_array_iter_free(self.end)
        # seq_simdjson_dom_array_free(self.arr)
        # logd("DomArrayIter.__del__ done")

    @always_inline
    fn has_element(self) -> Bool:
        return seq_simdjson_dom_array_iter_not_equal(self.it, self.end)

    @always_inline
    fn get(self) -> DomElement:
        var p = seq_simdjson_dom_array_iter_get(self.it)
        return DomElement(p)

    @always_inline
    fn get_int(self) -> Int:
        return seq_simdjson_dom_array_iter_get_int(self.it)

    @always_inline
    fn get_uint(self) -> Int:
        return seq_simdjson_dom_array_iter_get_uint(self.it)

    @always_inline
    fn get_float(self) -> Float64:
        return seq_simdjson_dom_array_iter_get_float(self.it)

    @always_inline
    fn get_bool(self) -> Bool:
        return seq_simdjson_dom_array_iter_get_bool(self.it)

    @always_inline
    fn get_str(self) -> String:
        var n: c_size_t = 0
        var s = seq_simdjson_dom_array_iter_get_str(
            self.it, UnsafePointer[c_size_t].address_of(n)
        )
        return c_str_to_string(s, n)

    @always_inline
    fn step(self):
        seq_simdjson_dom_array_iter_step(self.it)

    fn __repr__(self) -> String:
        return "<DomArrayIter: arr={self.arr} it={self.it} end={self.end}>"


@value
struct DomParser:
    var p: c_void_ptr

    @always_inline
    fn __init__(out self, max_capacity: Int):
        self.p = seq_simdjson_dom_parser_new(max_capacity)

    @always_inline
    fn __del__(owned self):
        # logd("DomParser.__del__")
        seq_simdjson_dom_parser_free(self.p)
        # logd("DomParser.__del__ done")

    fn _keepalive(self):
        pass

    @always_inline
    fn parse(self, s: String) raises -> DomElement:
        var p = seq_simdjson_dom_parser_parse(
            self.p, s.unsafe_cstr_ptr(), len(s)
        )
        if not seq_simdjson_dom_element_is_valid(p):
            raise Error("JSON parsing error: [" + s + "]")
        return DomElement(p)

    @always_inline
    fn parse(
        self, data: UnsafePointer[c_char], data_len: Int
    ) raises -> DomElement:
        var p = seq_simdjson_dom_parser_parse(self.p, data, data_len)
        if not seq_simdjson_dom_element_is_valid(p):
            raise Error(
                "JSON parsing error: [" + c_str_to_string(data, data_len) + "]"
            )
        return DomElement(p)

    fn __repr__(self) -> String:
        return "<DomParser: p={self.p}>"
