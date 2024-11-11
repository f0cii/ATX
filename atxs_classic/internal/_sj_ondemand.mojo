from sys import external_call
from sys.ffi import DLHandle


var __wrapper = _DLWrapper()


@value
struct _DLWrapper:
    var _handle: DLHandle

    var _seq_simdjson_ondemand_parser_new: DL_Fn[
        "seq_simdjson_ondemand_parser_new",
        fn (max_capacity: c_size_t) -> c_void_ptr,
    ]

    var _seq_simdjson_padded_string_new: DL_Fn[
        "seq_simdjson_padded_string_new",
        fn (s: c_char_ptr, len: c_size_t) -> c_void_ptr,
    ]

    var _seq_simdjson_ondemand_parser_parse: DL_Fn[
        "seq_simdjson_ondemand_parser_parse",
        fn (parser: c_void_ptr, data: c_void_ptr) -> c_void_ptr,
    ]

    var _seq_simdjson_ondemand_get_string_d: DL_Fn[
        "seq_simdjson_ondemand_get_string_d",
        fn (
            p: c_void_ptr,
            key: c_char_ptr,
            len: c_size_t,
            n: UnsafePointer[c_size_t],
        ) -> c_char_ptr,
    ]

    var _seq_simdjson_ondemand_get_string_v: DL_Fn[
        "seq_simdjson_ondemand_get_string_v",
        fn (
            p: c_void_ptr,
            key: c_char_ptr,
            len: c_size_t,
            n: UnsafePointer[c_size_t],
        ) -> c_char_ptr,
    ]

    var _seq_simdjson_ondemand_get_string_o: DL_Fn[
        "seq_simdjson_ondemand_get_string_o",
        fn (
            p: c_void_ptr,
            key: c_char_ptr,
            len: c_size_t,
            n: UnsafePointer[c_size_t],
        ) -> c_char_ptr,
    ]

    var _seq_simdjson_ondemand_get_int_d: DL_Fn[
        "seq_simdjson_ondemand_get_int_d",
        fn (doc: c_void_ptr, key: c_char_ptr, len: c_size_t) -> c_long,
    ]

    var _seq_simdjson_ondemand_get_uint_d: DL_Fn[
        "seq_simdjson_ondemand_get_uint_d",
        fn (doc: c_void_ptr, key: c_char_ptr, len: c_size_t) -> c_long,
    ]

    var _seq_simdjson_ondemand_get_float_d: DL_Fn[
        "seq_simdjson_ondemand_get_float_d",
        fn (doc: c_void_ptr, key: c_char_ptr, len: c_size_t) -> c_double,
    ]

    var _seq_simdjson_ondemand_get_bool_d: DL_Fn[
        "seq_simdjson_ondemand_get_bool_d",
        fn (doc: c_void_ptr, key: c_char_ptr, len: c_size_t) -> Bool,
    ]

    var _seq_simdjson_ondemand_get_int_v: DL_Fn[
        "seq_simdjson_ondemand_get_int_v",
        fn (value: c_void_ptr, key: c_char_ptr, len: c_size_t) -> c_long,
    ]

    var _seq_simdjson_ondemand_get_uint_v: DL_Fn[
        "seq_simdjson_ondemand_get_uint_v",
        fn (value: c_void_ptr, key: c_char_ptr, len: c_size_t) -> c_long,
    ]

    var _seq_simdjson_ondemand_get_float_v: DL_Fn[
        "seq_simdjson_ondemand_get_float_v",
        fn (value: c_void_ptr, key: c_char_ptr, len: c_size_t) -> c_double,
    ]

    var _seq_simdjson_ondemand_get_bool_v: DL_Fn[
        "seq_simdjson_ondemand_get_bool_v",
        fn (value: c_void_ptr, key: c_char_ptr, len: c_size_t) -> Bool,
    ]

    var _seq_simdjson_ondemand_int_v: DL_Fn[
        "seq_simdjson_ondemand_int_v", fn (p: c_void_ptr) -> c_long
    ]

    var _seq_simdjson_ondemand_uint_v: DL_Fn[
        "seq_simdjson_ondemand_uint_v", fn (p: c_void_ptr) -> c_long
    ]

    var _seq_simdjson_ondemand_float_v: DL_Fn[
        "seq_simdjson_ondemand_float_v", fn (p: c_void_ptr) -> c_double
    ]

    var _seq_simdjson_ondemand_bool_v: DL_Fn[
        "seq_simdjson_ondemand_bool_v", fn (p: c_void_ptr) -> Bool
    ]

    var _seq_simdjson_ondemand_string_v: DL_Fn[
        "seq_simdjson_ondemand_string_v",
        fn (p: c_void_ptr, n: UnsafePointer[c_size_t]) -> c_char_ptr,
    ]

    var _seq_simdjson_ondemand_object_v: DL_Fn[
        "seq_simdjson_ondemand_object_v", fn (p: c_void_ptr) -> c_void_ptr
    ]

    var _seq_simdjson_ondemand_array_v: DL_Fn[
        "seq_simdjson_ondemand_array_v", fn (p: c_void_ptr) -> c_void_ptr
    ]

    var _seq_simdjson_ondemand_get_int_o: DL_Fn[
        "seq_simdjson_ondemand_get_int_o",
        fn (p: c_void_ptr, key: c_char_ptr, len: c_size_t) -> c_long,
    ]

    var _seq_simdjson_ondemand_get_uint_o: DL_Fn[
        "seq_simdjson_ondemand_get_uint_o",
        fn (p: c_void_ptr, key: c_char_ptr, len: c_size_t) -> c_long,
    ]

    var _seq_simdjson_ondemand_get_float_o: DL_Fn[
        "seq_simdjson_ondemand_get_float_o",
        fn (p: c_void_ptr, key: c_char_ptr, len: c_size_t) -> c_double,
    ]

    var _seq_simdjson_ondemand_get_bool_o: DL_Fn[
        "seq_simdjson_ondemand_get_bool_o",
        fn (p: c_void_ptr, key: c_char_ptr, len: c_size_t) -> Bool,
    ]

    var _seq_simdjson_ondemand_get_value_d: DL_Fn[
        "seq_simdjson_ondemand_get_value_d",
        fn (p: c_void_ptr, key: c_char_ptr, len: c_size_t) -> c_void_ptr,
    ]

    var _seq_simdjson_ondemand_get_object_d: DL_Fn[
        "seq_simdjson_ondemand_get_object_d",
        fn (p: c_void_ptr, key: c_char_ptr, len: c_size_t) -> c_void_ptr,
    ]

    var _seq_simdjson_ondemand_get_array_d: DL_Fn[
        "seq_simdjson_ondemand_get_array_d",
        fn (p: c_void_ptr, key: c_char_ptr, len: c_size_t) -> c_void_ptr,
    ]

    var _seq_simdjson_ondemand_get_value_v: DL_Fn[
        "seq_simdjson_ondemand_get_value_v",
        fn (p: c_void_ptr, key: c_char_ptr, len: c_size_t) -> c_void_ptr,
    ]

    var _seq_simdjson_ondemand_get_object_v: DL_Fn[
        "seq_simdjson_ondemand_get_object_v",
        fn (p: c_void_ptr, key: c_char_ptr, len: c_size_t) -> c_void_ptr,
    ]

    var _seq_simdjson_ondemand_get_array_v: DL_Fn[
        "seq_simdjson_ondemand_get_array_v",
        fn (p: c_void_ptr, key: c_char_ptr, len: c_size_t) -> c_void_ptr,
    ]

    var _seq_simdjson_ondemand_get_value_o: DL_Fn[
        "seq_simdjson_ondemand_get_value_o",
        fn (p: c_void_ptr, key: c_char_ptr, len: c_size_t) -> c_void_ptr,
    ]

    var _seq_simdjson_ondemand_get_object_o: DL_Fn[
        "seq_simdjson_ondemand_get_object_o",
        fn (p: c_void_ptr, key: c_char_ptr, len: c_size_t) -> c_void_ptr,
    ]

    var _seq_simdjson_ondemand_get_array_o: DL_Fn[
        "seq_simdjson_ondemand_get_array_o",
        fn (p: c_void_ptr, key: c_char_ptr, len: c_size_t) -> c_void_ptr,
    ]

    var _seq_simdjson_ondemand_parser_free: DL_Fn[
        "seq_simdjson_ondemand_parser_free", fn (p: c_void_ptr) -> None
    ]

    var _seq_simdjson_padded_string_free: DL_Fn[
        "seq_simdjson_padded_string_free", fn (p: c_void_ptr) -> None
    ]

    var _seq_simdjson_ondemand_document_free: DL_Fn[
        "seq_simdjson_ondemand_document_free", fn (p: c_void_ptr) -> None
    ]

    var _seq_simdjson_ondemand_value_free: DL_Fn[
        "seq_simdjson_ondemand_value_free", fn (p: c_void_ptr) -> None
    ]

    var _seq_simdjson_ondemand_object_free: DL_Fn[
        "seq_simdjson_ondemand_object_free", fn (p: c_void_ptr) -> None
    ]

    var _seq_simdjson_ondemand_array_free: DL_Fn[
        "seq_simdjson_ondemand_array_free", fn (p: c_void_ptr) -> None
    ]

    var _seq_simdjson_ondemand_array_count_elements: DL_Fn[
        "seq_simdjson_ondemand_array_count_elements",
        fn (p: c_void_ptr) -> c_size_t,
    ]

    var _seq_simdjson_ondemand_array_at: DL_Fn[
        "seq_simdjson_ondemand_array_at",
        fn (p: c_void_ptr, index: c_size_t) -> c_void_ptr,
    ]

    var _seq_simdjson_ondemand_array_at_obj: DL_Fn[
        "seq_simdjson_ondemand_array_at_obj",
        fn (p: c_void_ptr, index: c_size_t) -> c_void_ptr,
    ]

    var _seq_simdjson_ondemand_array_at_arr: DL_Fn[
        "seq_simdjson_ondemand_array_at_arr",
        fn (p: c_void_ptr, index: c_size_t) -> c_void_ptr,
    ]

    var _seq_simdjson_ondemand_array_at_int: DL_Fn[
        "seq_simdjson_ondemand_array_at_int",
        fn (p: c_void_ptr, index: c_size_t) -> c_long,
    ]

    var _seq_simdjson_ondemand_array_at_uint: DL_Fn[
        "seq_simdjson_ondemand_array_at_uint",
        fn (p: c_void_ptr, index: c_size_t) -> c_long,
    ]

    var _seq_simdjson_ondemand_array_at_float: DL_Fn[
        "seq_simdjson_ondemand_array_at_float",
        fn (p: c_void_ptr, index: c_size_t) -> c_double,
    ]

    var _seq_simdjson_ondemand_array_at_bool: DL_Fn[
        "seq_simdjson_ondemand_array_at_bool",
        fn (p: c_void_ptr, index: c_size_t) -> Bool,
    ]

    var _seq_simdjson_ondemand_array_at_str: DL_Fn[
        "seq_simdjson_ondemand_array_at_str",
        fn (
            p: c_void_ptr, index: c_size_t, n: UnsafePointer[c_size_t]
        ) -> c_char_ptr,
    ]

    var _seq_simdjson_ondemand_value_type: DL_Fn[
        "seq_simdjson_ondemand_value_type", fn (p: c_void_ptr) -> c_long
    ]

    var _seq_simdjson_ondemand_array_iter_get: DL_Fn[
        "seq_simdjson_ondemand_array_iter_get", fn (p: c_void_ptr) -> c_void_ptr
    ]

    var _seq_simdjson_ondemand_array_iter_get_int: DL_Fn[
        "seq_simdjson_ondemand_array_iter_get_int", fn (p: c_void_ptr) -> c_long
    ]

    var _seq_simdjson_ondemand_array_iter_get_uint: DL_Fn[
        "seq_simdjson_ondemand_array_iter_get_uint",
        fn (p: c_void_ptr) -> c_long,
    ]

    var _seq_simdjson_ondemand_array_iter_get_float: DL_Fn[
        "seq_simdjson_ondemand_array_iter_get_float",
        fn (p: c_void_ptr) -> c_double,
    ]

    var _seq_simdjson_ondemand_array_iter_get_bool: DL_Fn[
        "seq_simdjson_ondemand_array_iter_get_bool", fn (p: c_void_ptr) -> Bool
    ]

    var _seq_simdjson_ondemand_array_iter_get_str: DL_Fn[
        "seq_simdjson_ondemand_array_iter_get_str",
        fn (p: c_void_ptr, n: UnsafePointer[c_size_t]) -> c_char_ptr,
    ]

    var _seq_simdjson_ondemand_array_iter_get_obj: DL_Fn[
        "seq_simdjson_ondemand_array_iter_get_obj",
        fn (p: c_void_ptr,) -> c_void_ptr,
    ]

    var _seq_simdjson_ondemand_array_iter_get_arr: DL_Fn[
        "seq_simdjson_ondemand_array_iter_get_arr",
        fn (p: c_void_ptr,) -> c_void_ptr,
    ]

    var _seq_simdjson_ondemand_array_begin: DL_Fn[
        "seq_simdjson_ondemand_array_begin", fn (p: c_void_ptr) -> c_void_ptr
    ]

    var _seq_simdjson_ondemand_array_end: DL_Fn[
        "seq_simdjson_ondemand_array_end", fn (p: c_void_ptr) -> c_void_ptr
    ]

    var _seq_simdjson_ondemand_array_iter_not_equal: DL_Fn[
        "seq_simdjson_ondemand_array_iter_not_equal",
        fn (lhs: c_void_ptr, rhs: c_void_ptr) -> Bool,
    ]

    var _seq_simdjson_ondemand_array_iter_step: DL_Fn[
        "seq_simdjson_ondemand_array_iter_step", fn (it: c_void_ptr) -> None
    ]

    var _seq_simdjson_ondemand_array_iter_free: DL_Fn[
        "seq_simdjson_ondemand_array_iter_free", fn (it: c_void_ptr) -> None
    ]

    fn __init__(inout self):
        self._handle = DLHandle(LIBNAME)

        self._seq_simdjson_ondemand_parser_new = self._handle
        self._seq_simdjson_padded_string_new = self._handle
        self._seq_simdjson_ondemand_parser_parse = self._handle
        self._seq_simdjson_ondemand_get_string_d = self._handle
        self._seq_simdjson_ondemand_get_string_v = self._handle
        self._seq_simdjson_ondemand_get_string_o = self._handle
        self._seq_simdjson_ondemand_get_int_d = self._handle
        self._seq_simdjson_ondemand_get_uint_d = self._handle
        self._seq_simdjson_ondemand_get_float_d = self._handle
        self._seq_simdjson_ondemand_get_bool_d = self._handle
        self._seq_simdjson_ondemand_get_int_v = self._handle
        self._seq_simdjson_ondemand_get_uint_v = self._handle
        self._seq_simdjson_ondemand_get_float_v = self._handle
        self._seq_simdjson_ondemand_get_bool_v = self._handle
        self._seq_simdjson_ondemand_int_v = self._handle
        self._seq_simdjson_ondemand_uint_v = self._handle
        self._seq_simdjson_ondemand_float_v = self._handle
        self._seq_simdjson_ondemand_bool_v = self._handle
        self._seq_simdjson_ondemand_string_v = self._handle
        self._seq_simdjson_ondemand_object_v = self._handle
        self._seq_simdjson_ondemand_array_v = self._handle
        self._seq_simdjson_ondemand_get_int_o = self._handle
        self._seq_simdjson_ondemand_get_uint_o = self._handle
        self._seq_simdjson_ondemand_get_float_o = self._handle
        self._seq_simdjson_ondemand_get_bool_o = self._handle
        self._seq_simdjson_ondemand_get_value_d = self._handle
        self._seq_simdjson_ondemand_get_object_d = self._handle
        self._seq_simdjson_ondemand_get_array_d = self._handle
        self._seq_simdjson_ondemand_get_value_v = self._handle
        self._seq_simdjson_ondemand_get_object_v = self._handle
        self._seq_simdjson_ondemand_get_array_v = self._handle
        self._seq_simdjson_ondemand_get_value_o = self._handle
        self._seq_simdjson_ondemand_get_object_o = self._handle
        self._seq_simdjson_ondemand_get_array_o = self._handle
        self._seq_simdjson_ondemand_parser_free = self._handle
        self._seq_simdjson_padded_string_free = self._handle
        self._seq_simdjson_ondemand_document_free = self._handle
        self._seq_simdjson_ondemand_value_free = self._handle
        self._seq_simdjson_ondemand_object_free = self._handle
        self._seq_simdjson_ondemand_array_free = self._handle
        self._seq_simdjson_ondemand_array_count_elements = self._handle
        self._seq_simdjson_ondemand_array_at = self._handle
        self._seq_simdjson_ondemand_array_at_obj = self._handle
        self._seq_simdjson_ondemand_array_at_arr = self._handle
        self._seq_simdjson_ondemand_array_at_int = self._handle
        self._seq_simdjson_ondemand_array_at_uint = self._handle
        self._seq_simdjson_ondemand_array_at_float = self._handle
        self._seq_simdjson_ondemand_array_at_bool = self._handle
        self._seq_simdjson_ondemand_array_at_str = self._handle
        self._seq_simdjson_ondemand_value_type = self._handle
        self._seq_simdjson_ondemand_array_iter_get = self._handle
        self._seq_simdjson_ondemand_array_iter_get_int = self._handle
        self._seq_simdjson_ondemand_array_iter_get_uint = self._handle
        self._seq_simdjson_ondemand_array_iter_get_float = self._handle
        self._seq_simdjson_ondemand_array_iter_get_bool = self._handle
        self._seq_simdjson_ondemand_array_iter_get_str = self._handle
        self._seq_simdjson_ondemand_array_iter_get_obj = self._handle
        self._seq_simdjson_ondemand_array_iter_get_arr = self._handle
        self._seq_simdjson_ondemand_array_begin = self._handle
        self._seq_simdjson_ondemand_array_end = self._handle
        self._seq_simdjson_ondemand_array_iter_not_equal = self._handle
        self._seq_simdjson_ondemand_array_iter_step = self._handle
        self._seq_simdjson_ondemand_array_iter_free = self._handle


@always_inline
fn seq_simdjson_ondemand_parser_new(max_capacity: c_size_t) -> c_void_ptr:
    return __wrapper._seq_simdjson_ondemand_parser_new.call(max_capacity)


@always_inline
fn seq_simdjson_padded_string_new(s: c_char_ptr, len: c_size_t) -> c_void_ptr:
    return __wrapper._seq_simdjson_padded_string_new.call(s, len)


@always_inline
fn seq_simdjson_ondemand_parser_parse(
    parser: c_void_ptr, data: c_void_ptr
) -> c_void_ptr:
    return __wrapper._seq_simdjson_ondemand_parser_parse.call(parser, data)


@always_inline
fn seq_simdjson_ondemand_get_string_d(
    p: c_void_ptr,
    key: c_char_ptr,
    len: c_size_t,
    n: UnsafePointer[c_size_t],
) -> c_char_ptr:
    return __wrapper._seq_simdjson_ondemand_get_string_d.call(p, key, len, n)


@always_inline
fn seq_simdjson_ondemand_get_string_v(
    p: c_void_ptr,
    key: c_char_ptr,
    len: c_size_t,
    n: UnsafePointer[c_size_t],
) -> c_char_ptr:
    return __wrapper._seq_simdjson_ondemand_get_string_v.call(p, key, len, n)


@always_inline
fn seq_simdjson_ondemand_get_string_o(
    p: c_void_ptr,
    key: c_char_ptr,
    len: c_size_t,
    n: UnsafePointer[c_size_t],
) -> c_char_ptr:
    return __wrapper._seq_simdjson_ondemand_get_string_o.call(p, key, len, n)


@always_inline
fn seq_simdjson_ondemand_get_int_d(
    doc: c_void_ptr, key: c_char_ptr, len: c_size_t
) -> c_long:
    return __wrapper._seq_simdjson_ondemand_get_int_d.call(doc, key, len)


@always_inline
fn seq_simdjson_ondemand_get_uint_d(
    doc: c_void_ptr, key: c_char_ptr, len: c_size_t
) -> c_long:
    return __wrapper._seq_simdjson_ondemand_get_uint_d.call(doc, key, len)


@always_inline
fn seq_simdjson_ondemand_get_float_d(
    doc: c_void_ptr, key: c_char_ptr, len: c_size_t
) -> c_double:
    return __wrapper._seq_simdjson_ondemand_get_float_d.call(doc, key, len)


@always_inline
fn seq_simdjson_ondemand_get_bool_d(
    doc: c_void_ptr, key: c_char_ptr, len: c_size_t
) -> Bool:
    return __wrapper._seq_simdjson_ondemand_get_bool_d.call(doc, key, len)


@always_inline
fn seq_simdjson_ondemand_get_int_v(
    value: c_void_ptr, key: c_char_ptr, len: c_size_t
) -> c_long:
    return __wrapper._seq_simdjson_ondemand_get_int_v.call(value, key, len)


@always_inline
fn seq_simdjson_ondemand_get_uint_v(
    value: c_void_ptr, key: c_char_ptr, len: c_size_t
) -> c_long:
    return __wrapper._seq_simdjson_ondemand_get_uint_v.call(value, key, len)


@always_inline
fn seq_simdjson_ondemand_get_float_v(
    value: c_void_ptr, key: c_char_ptr, len: c_size_t
) -> c_double:
    return __wrapper._seq_simdjson_ondemand_get_float_v.call(value, key, len)


@always_inline
fn seq_simdjson_ondemand_get_bool_v(
    value: c_void_ptr, key: c_char_ptr, len: c_size_t
) -> Bool:
    return __wrapper._seq_simdjson_ondemand_get_bool_v.call(value, key, len)


@always_inline
fn seq_simdjson_ondemand_int_v(p: c_void_ptr) -> c_long:
    return __wrapper._seq_simdjson_ondemand_int_v.call(p)


@always_inline
fn seq_simdjson_ondemand_uint_v(p: c_void_ptr) -> c_long:
    return __wrapper._seq_simdjson_ondemand_uint_v.call(p)


@always_inline
fn seq_simdjson_ondemand_float_v(p: c_void_ptr) -> c_double:
    return __wrapper._seq_simdjson_ondemand_float_v.call(p)


@always_inline
fn seq_simdjson_ondemand_bool_v(p: c_void_ptr) -> Bool:
    return __wrapper._seq_simdjson_ondemand_bool_v.call(p)


@always_inline
fn seq_simdjson_ondemand_string_v(
    p: c_void_ptr, n: UnsafePointer[c_size_t]
) -> c_char_ptr:
    return __wrapper._seq_simdjson_ondemand_string_v.call(p, n)


@always_inline
fn seq_simdjson_ondemand_object_v(p: c_void_ptr) -> c_void_ptr:
    return __wrapper._seq_simdjson_ondemand_object_v.call(p)


@always_inline
fn seq_simdjson_ondemand_array_v(p: c_void_ptr) -> c_void_ptr:
    return __wrapper._seq_simdjson_ondemand_array_v.call(p)


@always_inline
fn seq_simdjson_ondemand_get_int_o(
    p: c_void_ptr, key: c_char_ptr, len: c_size_t
) -> c_long:
    return __wrapper._seq_simdjson_ondemand_get_int_o.call(p, key, len)


@always_inline
fn seq_simdjson_ondemand_get_uint_o(
    p: c_void_ptr, key: c_char_ptr, len: c_size_t
) -> c_long:
    return __wrapper._seq_simdjson_ondemand_get_uint_o.call(p, key, len)


@always_inline
fn seq_simdjson_ondemand_get_float_o(
    p: c_void_ptr, key: c_char_ptr, len: c_size_t
) -> c_double:
    return __wrapper._seq_simdjson_ondemand_get_float_o.call(p, key, len)


@always_inline
fn seq_simdjson_ondemand_get_bool_o(
    p: c_void_ptr, key: c_char_ptr, len: c_size_t
) -> Bool:
    return __wrapper._seq_simdjson_ondemand_get_bool_o.call(p, key, len)


@always_inline
fn seq_simdjson_ondemand_get_value_d(
    p: c_void_ptr, key: c_char_ptr, len: c_size_t
) -> c_void_ptr:
    return __wrapper._seq_simdjson_ondemand_get_value_d.call(p, key, len)


@always_inline
fn seq_simdjson_ondemand_get_object_d(
    p: c_void_ptr, key: c_char_ptr, len: c_size_t
) -> c_void_ptr:
    return __wrapper._seq_simdjson_ondemand_get_object_d.call(p, key, len)


@always_inline
fn seq_simdjson_ondemand_get_array_d(
    p: c_void_ptr, key: c_char_ptr, len: c_size_t
) -> c_void_ptr:
    return __wrapper._seq_simdjson_ondemand_get_array_d.call(p, key, len)


@always_inline
fn seq_simdjson_ondemand_get_value_v(
    p: c_void_ptr, key: c_char_ptr, len: c_size_t
) -> c_void_ptr:
    return __wrapper._seq_simdjson_ondemand_get_value_v.call(p, key, len)


@always_inline
fn seq_simdjson_ondemand_get_object_v(
    p: c_void_ptr, key: c_char_ptr, len: c_size_t
) -> c_void_ptr:
    return __wrapper._seq_simdjson_ondemand_get_object_v.call(p, key, len)


@always_inline
fn seq_simdjson_ondemand_get_array_v(
    p: c_void_ptr, key: c_char_ptr, len: c_size_t
) -> c_void_ptr:
    return __wrapper._seq_simdjson_ondemand_get_array_v.call(p, key, len)


@always_inline
fn seq_simdjson_ondemand_get_value_o(
    p: c_void_ptr, key: c_char_ptr, len: c_size_t
) -> c_void_ptr:
    return __wrapper._seq_simdjson_ondemand_get_value_o.call(p, key, len)


@always_inline
fn seq_simdjson_ondemand_get_object_o(
    p: c_void_ptr, key: c_char_ptr, len: c_size_t
) -> c_void_ptr:
    return __wrapper._seq_simdjson_ondemand_get_object_o.call(p, key, len)


@always_inline
fn seq_simdjson_ondemand_get_array_o(
    p: c_void_ptr, key: c_char_ptr, len: c_size_t
) -> c_void_ptr:
    return __wrapper._seq_simdjson_ondemand_get_array_o.call(p, key, len)


@always_inline
fn seq_simdjson_ondemand_parser_free(p: c_void_ptr) -> None:
    return __wrapper._seq_simdjson_ondemand_parser_free.call(p)


@always_inline
fn seq_simdjson_padded_string_free(p: c_void_ptr) -> None:
    return __wrapper._seq_simdjson_padded_string_free.call(p)


@always_inline
fn seq_simdjson_ondemand_document_free(p: c_void_ptr) -> None:
    return __wrapper._seq_simdjson_ondemand_document_free.call(p)


@always_inline
fn seq_simdjson_ondemand_value_free(p: c_void_ptr) -> None:
    return __wrapper._seq_simdjson_ondemand_value_free.call(p)


@always_inline
fn seq_simdjson_ondemand_object_free(p: c_void_ptr) -> None:
    return __wrapper._seq_simdjson_ondemand_object_free.call(p)


@always_inline
fn seq_simdjson_ondemand_array_free(p: c_void_ptr) -> None:
    return __wrapper._seq_simdjson_ondemand_array_free.call(p)


@always_inline
fn seq_simdjson_ondemand_array_count_elements(p: c_void_ptr) -> c_size_t:
    return __wrapper._seq_simdjson_ondemand_array_count_elements.call(p)


@always_inline
fn seq_simdjson_ondemand_array_at(p: c_void_ptr, index: c_size_t) -> c_void_ptr:
    return __wrapper._seq_simdjson_ondemand_array_at.call(p, index)


@always_inline
fn seq_simdjson_ondemand_array_at_obj(
    p: c_void_ptr, index: c_size_t
) -> c_void_ptr:
    return __wrapper._seq_simdjson_ondemand_array_at_obj.call(p, index)


@always_inline
fn seq_simdjson_ondemand_array_at_arr(
    p: c_void_ptr, index: c_size_t
) -> c_void_ptr:
    return __wrapper._seq_simdjson_ondemand_array_at_arr.call(p, index)


@always_inline
fn seq_simdjson_ondemand_array_at_int(p: c_void_ptr, index: c_size_t) -> c_long:
    return __wrapper._seq_simdjson_ondemand_array_at_int.call(p, index)


@always_inline
fn seq_simdjson_ondemand_array_at_uint(
    p: c_void_ptr, index: c_size_t
) -> c_long:
    return __wrapper._seq_simdjson_ondemand_array_at_uint.call(p, index)


@always_inline
fn seq_simdjson_ondemand_array_at_float(
    p: c_void_ptr, index: c_size_t
) -> c_double:
    return __wrapper._seq_simdjson_ondemand_array_at_float.call(p, index)


@always_inline
fn seq_simdjson_ondemand_array_at_bool(p: c_void_ptr, index: c_size_t) -> Bool:
    return __wrapper._seq_simdjson_ondemand_array_at_bool.call(p, index)


@always_inline
fn seq_simdjson_ondemand_array_at_str(
    p: c_void_ptr, index: c_size_t, n: UnsafePointer[c_size_t]
) -> c_char_ptr:
    return __wrapper._seq_simdjson_ondemand_array_at_str.call(p, index, n)


@always_inline
fn seq_simdjson_ondemand_value_type(p: c_void_ptr) -> c_long:
    return __wrapper._seq_simdjson_ondemand_value_type.call(p)


@always_inline
fn seq_simdjson_ondemand_array_iter_get(p: c_void_ptr) -> c_void_ptr:
    return __wrapper._seq_simdjson_ondemand_array_iter_get.call(p)


@always_inline
fn seq_simdjson_ondemand_array_iter_get_int(p: c_void_ptr) -> c_long:
    return __wrapper._seq_simdjson_ondemand_array_iter_get_int.call(p)


@always_inline
fn seq_simdjson_ondemand_array_iter_get_uint(p: c_void_ptr) -> c_long:
    return __wrapper._seq_simdjson_ondemand_array_iter_get_uint.call(p)


@always_inline
fn seq_simdjson_ondemand_array_iter_get_float(p: c_void_ptr) -> c_double:
    return __wrapper._seq_simdjson_ondemand_array_iter_get_float.call(p)


@always_inline
fn seq_simdjson_ondemand_array_iter_get_bool(p: c_void_ptr) -> Bool:
    return __wrapper._seq_simdjson_ondemand_array_iter_get_bool.call(p)


@always_inline
fn seq_simdjson_ondemand_array_iter_get_str(
    p: c_void_ptr, n: UnsafePointer[c_size_t]
) -> c_char_ptr:
    return __wrapper._seq_simdjson_ondemand_array_iter_get_str.call(p, n)


@always_inline
fn seq_simdjson_ondemand_array_iter_get_obj(
    p: c_void_ptr,
) -> c_void_ptr:
    return __wrapper._seq_simdjson_ondemand_array_iter_get_obj.call(p)


@always_inline
fn seq_simdjson_ondemand_array_iter_get_arr(
    p: c_void_ptr,
) -> c_void_ptr:
    return __wrapper._seq_simdjson_ondemand_array_iter_get_arr.call(p)


@always_inline
fn seq_simdjson_ondemand_array_begin(p: c_void_ptr) -> c_void_ptr:
    return __wrapper._seq_simdjson_ondemand_array_begin.call(p)


@always_inline
fn seq_simdjson_ondemand_array_end(p: c_void_ptr) -> c_void_ptr:
    return __wrapper._seq_simdjson_ondemand_array_end.call(p)


@always_inline
fn seq_simdjson_ondemand_array_iter_not_equal(
    lhs: c_void_ptr, rhs: c_void_ptr
) -> Bool:
    return __wrapper._seq_simdjson_ondemand_array_iter_not_equal.call(lhs, rhs)


@always_inline
fn seq_simdjson_ondemand_array_iter_step(it: c_void_ptr) -> None:
    return __wrapper._seq_simdjson_ondemand_array_iter_step.call(it)


@always_inline
fn seq_simdjson_ondemand_array_iter_free(it: c_void_ptr) -> None:
    return __wrapper._seq_simdjson_ondemand_array_iter_free.call(it)


struct OndemandValue:
    var p: c_void_ptr

    @always_inline
    fn __init__(inout self, p: c_void_ptr):
        self.p = p

    @always_inline
    fn __del__(owned self):
        # logd("OndemandValue.__del__")
        seq_simdjson_ondemand_value_free(self.p)
        # logd("OndemandValue.__del__ done")

    @always_inline
    fn int(self) -> Int:
        return int(seq_simdjson_ondemand_int_v(self.p))

    @always_inline
    fn __copyinit__(inout self, existing: Self):
        self.p = existing.p

    @always_inline
    fn uint(self) -> Int:
        return int(seq_simdjson_ondemand_uint_v(self.p))

    @always_inline
    fn float(self) -> Float64:
        return seq_simdjson_ondemand_float_v(self.p)

    @always_inline
    fn bool(self) -> Bool:
        return seq_simdjson_ondemand_bool_v(self.p)

    @always_inline
    fn str(self) -> String:
        var n: c_size_t = 0
        var s = seq_simdjson_ondemand_string_v(
            self.p, UnsafePointer[c_size_t].address_of(n)
        )
        return c_str_to_string(s, n)

    @always_inline
    fn object(self) -> OndemandObject:
        var p = seq_simdjson_ondemand_object_v(self.p)
        return OndemandObject(p)

    @always_inline
    fn array(self) -> OndemandArray:
        var p = seq_simdjson_ondemand_array_v(self.p)
        return OndemandArray(p)

    @always_inline
    fn type(self) -> Int:
        return int(seq_simdjson_ondemand_value_type(self.p))

    @always_inline
    fn type_desc(self) -> String:
        var type_ = seq_simdjson_ondemand_value_type(self.p)
        if type_ == 1:
            return "array"
        elif type_ == 2:
            return "object"
        elif type_ == 3:
            return "number"
        elif type_ == 4:
            return "string"
        elif type_ == 5:
            return "boolean"
        elif type_ == 6:
            return "null"
        else:
            return "--"

    @always_inline
    fn get_int(self, key: StringLiteral) -> Int:
        return int(
            seq_simdjson_ondemand_get_int_v(
                self.p, key.unsafe_cstr_ptr(), len(key)
            )
        )

    @always_inline
    fn get_uint(self, key: StringLiteral) -> Int:
        return int(
            seq_simdjson_ondemand_get_uint_v(
                self.p, key.unsafe_cstr_ptr(), len(key)
            )
        )

    @always_inline
    fn get_float(self, key: StringLiteral) -> Float64:
        return seq_simdjson_ondemand_get_float_v(
            self.p, key.unsafe_cstr_ptr(), len(key)
        )

    @always_inline
    fn get_bool(self, key: StringLiteral) -> Bool:
        return seq_simdjson_ondemand_get_bool_v(
            self.p, key.unsafe_cstr_ptr(), len(key)
        )

    @always_inline
    fn get_str(self, key: StringLiteral) -> String:
        var n: c_size_t = 0
        var s = seq_simdjson_ondemand_get_string_v(
            self.p,
            key.unsafe_cstr_ptr(),
            len(key),
            UnsafePointer[c_size_t].address_of(n),
        )
        return c_str_to_string(s, n)

    @always_inline
    fn get_object(self, key: StringLiteral) -> OndemandObject:
        var p = seq_simdjson_ondemand_get_object_v(
            self.p, key.unsafe_cstr_ptr(), len(key)
        )
        return OndemandObject(p)

    @always_inline
    fn get_array(self, key: StringLiteral) -> OndemandArray:
        var p = seq_simdjson_ondemand_get_array_v(
            self.p, key.unsafe_cstr_ptr(), len(key)
        )
        return OndemandArray(p)

    fn __repr__(self) -> String:
        return "<OndemandValue: ctx={self.ctx} p={self.p}>"


@value
struct OndemandArray(Sized):
    var p: c_void_ptr

    @always_inline
    fn __init__(inout self, p: c_void_ptr):
        self.p = p

    @always_inline
    fn __del__(owned self):
        # logd("OndemandArray.__del__")
        seq_simdjson_ondemand_array_free(self.p)
        # logd("OndemandArray.__del__ done")

    @always_inline
    fn __len__(self) -> Int:
        return seq_simdjson_ondemand_array_count_elements(self.p)

    @always_inline
    fn at(self, index: Int) -> OndemandValue:
        var p = seq_simdjson_ondemand_array_at(self.p, index)
        return OndemandValue(p)

    @always_inline
    fn at_int(self, index: Int) -> Int:
        return int(seq_simdjson_ondemand_array_at_int(self.p, index))

    @always_inline
    fn at_uint(self, index: Int) -> Int:
        return int(seq_simdjson_ondemand_array_at_uint(self.p, index))

    @always_inline
    fn at_float(self, index: Int) -> Float64:
        return seq_simdjson_ondemand_array_at_float(self.p, index)

    @always_inline
    fn at_bool(self, index: Int) -> Bool:
        return seq_simdjson_ondemand_array_at_bool(self.p, index)

    @always_inline
    fn at_str(self, index: Int) -> String:
        var n: c_size_t = 0
        var s = seq_simdjson_ondemand_array_at_str(
            self.p, index, UnsafePointer[c_size_t].address_of(n)
        )
        return c_str_to_string(s, n)

    @always_inline
    fn at_object(self, index: Int) -> OndemandObject:
        var p = seq_simdjson_ondemand_array_at_obj(self.p, index)
        return OndemandObject(p)

    @always_inline
    fn at_array(self, index: Int) -> OndemandArray:
        var p = seq_simdjson_ondemand_array_at_arr(self.p, index)
        return OndemandArray(p)

    @always_inline
    fn iter(self) -> OndemandArrayIter:
        return OndemandArrayIter(self.p)

    fn __repr__(self) -> String:
        return "<OndemandArray: p={self.p}>"


@value
struct OndemandObject:
    var p: c_void_ptr

    @always_inline
    fn __init__(inout self, p: c_void_ptr):
        self.p = p

    @always_inline
    fn __del__(owned self):
        # logd("OndemandObject.__del__")
        seq_simdjson_ondemand_object_free(self.p)
        # logd("OndemandObject.__del__ done")

    @always_inline
    fn get_int(self, key: StringLiteral) -> Int:
        return int(
            seq_simdjson_ondemand_get_int_o(
                self.p, key.unsafe_cstr_ptr(), len(key)
            )
        )

    @always_inline
    fn get_uint(self, key: StringLiteral) -> Int:
        return int(
            seq_simdjson_ondemand_get_uint_o(
                self.p, key.unsafe_cstr_ptr(), len(key)
            )
        )

    @always_inline
    fn get_float(self, key: StringLiteral) -> Float64:
        return seq_simdjson_ondemand_get_float_o(
            self.p, key.unsafe_cstr_ptr(), len(key)
        )

    @always_inline
    fn get_bool(self, key: StringLiteral) -> Bool:
        return seq_simdjson_ondemand_get_bool_o(
            self.p, key.unsafe_cstr_ptr(), len(key)
        )

    @always_inline
    fn get_str(self, key: StringLiteral) -> String:
        var n: c_size_t = 0
        var s = seq_simdjson_ondemand_get_string_o(
            self.p,
            key.unsafe_cstr_ptr(),
            len(key),
            UnsafePointer[c_size_t].address_of(n),
        )
        if n == 0:
            return String("")
        return c_str_to_string(s, n)
        # return String(s.bitcast[UInt8](), n)

    @always_inline
    fn get_object(self, key: StringLiteral) -> OndemandObject:
        var p = seq_simdjson_ondemand_get_object_o(
            self.p, key.unsafe_cstr_ptr(), len(key)
        )
        return OndemandObject(p)

    @always_inline
    fn get_array(self, key: StringLiteral) -> OndemandArray:
        var p = seq_simdjson_ondemand_get_array_o(
            self.p, key.unsafe_cstr_ptr(), len(key)
        )
        return OndemandArray(p)

    fn __repr__(self) -> String:
        return "<OndemandObject: p={self.p}>"


@value
struct OndemandArrayIter:
    var arr: c_void_ptr
    var it: c_void_ptr
    var end: c_void_ptr

    @always_inline
    fn __init__(
        inout self,
        arr: c_void_ptr,
        it: c_void_ptr,
        end: c_void_ptr,
    ):
        self.arr = arr
        self.it = it
        self.end = end

    @always_inline
    fn __init__(inout self, arr: c_void_ptr):
        self.arr = arr
        self.it = seq_simdjson_ondemand_array_begin(arr)
        self.end = seq_simdjson_ondemand_array_end(arr)

    @always_inline
    fn __del__(owned self):
        # logd("OndemandArrayIter.__del__")
        seq_simdjson_ondemand_array_iter_free(self.it)
        seq_simdjson_ondemand_array_iter_free(self.end)
        # seq_simdjson_ondemand_array_free(self.arr)
        # logd("OndemandArrayIter.__del__ done")

    @always_inline
    fn has_value(self) -> Bool:
        return seq_simdjson_ondemand_array_iter_not_equal(self.it, self.end)

    @always_inline
    fn get(self) -> OndemandValue:
        var p = seq_simdjson_ondemand_array_iter_get(self.it)
        return OndemandValue(p)

    @always_inline
    fn get_object(self) -> OndemandObject:
        var p = seq_simdjson_ondemand_array_iter_get_obj(self.it)
        return OndemandObject(p)

    @always_inline
    fn get_array(self) -> OndemandArray:
        var p = seq_simdjson_ondemand_array_iter_get_arr(self.it)
        return OndemandArray(p)

    @always_inline
    fn get_int(self) -> Int:
        return int(seq_simdjson_ondemand_array_iter_get_int(self.it))

    @always_inline
    fn get_uint(self) -> Int:
        return int(seq_simdjson_ondemand_array_iter_get_uint(self.it))

    @always_inline
    fn get_float(self) -> Float64:
        return seq_simdjson_ondemand_array_iter_get_float(self.it)

    @always_inline
    fn get_bool(self) -> Bool:
        return seq_simdjson_ondemand_array_iter_get_bool(self.it)

    @always_inline
    fn get_str(self) -> String:
        var n: c_size_t = 0
        var s = seq_simdjson_ondemand_array_iter_get_str(
            self.it, UnsafePointer[c_size_t].address_of(n)
        )
        return c_str_to_string(s, n)

    @always_inline
    fn step(self):
        seq_simdjson_ondemand_array_iter_step(self.it)

    fn __repr__(self) -> String:
        return "<DomArrayIter: arr={self.arr} it={self.it} end={self.end}>"


@value
struct OndemandDocument:
    var padded_string: c_void_ptr
    var doc: c_void_ptr

    @always_inline
    fn __init__(
        inout self,
        padded_string: c_void_ptr,
        doc: c_void_ptr,
    ):
        self.padded_string = padded_string
        self.doc = doc

    @always_inline
    fn __del__(owned self):
        # logd("OndemandDocument.__del__")
        seq_simdjson_ondemand_document_free(self.doc)
        seq_simdjson_padded_string_free(self.padded_string)
        # logd("OndemandDocument.__del__ done")

    @always_inline
    fn get_int(self, key: StringLiteral) -> Int:
        var v = seq_simdjson_ondemand_get_int_d(
            self.doc, key.unsafe_cstr_ptr(), len(key)
        )
        return int(v)

    @always_inline
    fn get_uint(self, key: StringLiteral) -> Int:
        return int(
            seq_simdjson_ondemand_get_uint_d(
                self.doc,
                key.unsafe_cstr_ptr(),
                len(key),
            )
        )

    @always_inline
    fn get_float(self, key: StringLiteral) -> Float64:
        return seq_simdjson_ondemand_get_float_d(
            self.doc, key.unsafe_cstr_ptr(), len(key)
        )

    @always_inline
    fn get_bool(self, key: StringLiteral) -> Bool:
        return seq_simdjson_ondemand_get_bool_d(
            self.doc, key.unsafe_cstr_ptr(), len(key)
        )

    @always_inline
    fn get_str(self, key: StringLiteral) -> String:
        var n: c_size_t = 0
        var s = seq_simdjson_ondemand_get_string_d(
            self.doc,
            key.unsafe_cstr_ptr(),
            len(key),
            UnsafePointer[c_size_t].address_of(n),
        )
        return c_str_to_string(s, n)

    @always_inline
    fn get_object(self, key: StringLiteral) -> OndemandObject:
        var p = seq_simdjson_ondemand_get_object_d(
            self.doc, key.unsafe_cstr_ptr(), len(key)
        )
        return OndemandObject(p)

    @always_inline
    fn get_array(self, key: StringLiteral) -> OndemandArray:
        var p = seq_simdjson_ondemand_get_array_d(
            self.doc, key.unsafe_cstr_ptr(), len(key)
        )
        return OndemandArray(p)

    fn __repr__(self) -> String:
        return (
            "<OndemandDocument: padded_string={self._padded_string}"
            " doc={self._doc}>"
        )


@value
struct OndemandParser:
    var parser: c_void_ptr

    @always_inline
    fn __init__(inout self, max_capacity: Int):
        self.parser = seq_simdjson_ondemand_parser_new(max_capacity)

    @always_inline
    fn __del__(owned self):
        # logd("OndemandParser.__del__")
        seq_simdjson_ondemand_parser_free(self.parser)
        # logd("OndemandParser.__del__ done")

    # @always_inline
    # fn parse(self, s: StringRef) -> OndemandDocument:
    #     var padded_string = seq_simdjson_padded_string_new(
    #         s.unsafe_ptr(), len(s)
    #     )
    #     var doc = seq_simdjson_ondemand_parser_parse(self.parser, padded_string)
    #     return OndemandDocument(padded_string, doc)

    @always_inline
    fn parse(self, s: String) -> OndemandDocument:
        var padded_string = seq_simdjson_padded_string_new(
            s.unsafe_cstr_ptr(), len(s)
        )
        var doc = seq_simdjson_ondemand_parser_parse(self.parser, padded_string)
        return OndemandDocument(padded_string, doc)

    fn __repr__(self) -> String:
        return "<OndemandParser: p={self.p}>"
