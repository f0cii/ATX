from collections.list import List
from sys.ffi import DLHandle


var __wrapper = _DLWrapper()


@value
struct _DLWrapper:
    var _handle: DLHandle

    var _seq_get_next_cache_key: DL_Fn["seq_get_next_cache_key", fn () -> Int64]
    var _seq_set_string_in_cache: DL_Fn[
        "seq_set_string_in_cache",
        fn (key: Int64, value: c_char_ptr, value_len: c_size_t) -> c_char_ptr,
    ]
    var _seq_get_string_in_cache: DL_Fn[
        "seq_get_string_in_cache",
        fn (key: Int64, result_len: UnsafePointer[c_size_t]) -> c_char_ptr,
    ]
    var _seq_free_string_in_cache: DL_Fn[
        "seq_free_string_in_cache", fn (key: Int64) -> Bool
    ]

    fn __init__(out self):
        self._handle = DLHandle(LIBNAME)

        self._seq_get_next_cache_key = self._handle
        self._seq_set_string_in_cache = self._handle
        self._seq_get_string_in_cache = self._handle
        self._seq_free_string_in_cache = self._handle


@always_inline
fn seq_get_next_cache_key() -> Int64:
    return __wrapper.._seq_get_next_cache_key.call()


@always_inline
fn seq_set_string_in_cache(
    key: Int64, value: c_char_ptr, value_len: c_size_t
) -> c_char_ptr:
    return __wrapper.._seq_set_string_in_cache.call(key, value, value_len)


@always_inline
fn seq_get_string_in_cache(
    key: Int64, result_len: UnsafePointer[c_size_t]
) -> c_char_ptr:
    return __wrapper.._seq_get_string_in_cache.call(key, result_len)


@always_inline
fn seq_free_string_in_cache(key: Int64) -> Bool:
    return __wrapper.._seq_free_string_in_cache.call(key)
