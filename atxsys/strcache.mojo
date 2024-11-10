from collections.list import List
from sys.ffi import DLHandle


var _scw = _StrCacheWrapper()


@value
struct _StrCacheWrapper:
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

    fn __init__(inout self):
        self._handle = DLHandle(LIBNAME)

        self._seq_get_next_cache_key = self._handle
        self._seq_set_string_in_cache = self._handle
        self._seq_get_string_in_cache = self._handle
        self._seq_free_string_in_cache = self._handle


@always_inline
fn seq_get_next_cache_key() -> Int64:
    return _scw._seq_get_next_cache_key.call()


@always_inline
fn seq_set_string_in_cache(
    key: Int64, value: c_char_ptr, value_len: c_size_t
) -> c_char_ptr:
    return _scw._seq_set_string_in_cache.call(key, value, value_len)


@always_inline
fn seq_get_string_in_cache(
    key: Int64, result_len: UnsafePointer[c_size_t]
) -> c_char_ptr:
    return _scw._seq_get_string_in_cache.call(key, result_len)


@always_inline
fn seq_free_string_in_cache(key: Int64) -> Bool:
    return _scw._seq_free_string_in_cache.call(key)


@value
struct StringCache:
    fn __init__(inout self):
        pass

    @staticmethod
    fn set_string(s: String) -> Tuple[Int64, CString]:
        var key = seq_get_next_cache_key()
        var length = len(s)
        var result = seq_set_string_in_cache(key, s.unsafe_cstr_ptr(), length)
        return Tuple[Int64, CString](key, CString(result, length))

    @staticmethod
    fn get_string(key: Int64) -> Tuple[Int64, CString]:
        var length: c_size_t = 0
        var result = seq_get_string_in_cache(
            key, UnsafePointer[c_size_t].address_of(length)
        )
        return Tuple[Int64, CString](key, CString(result, length))

    @staticmethod
    fn free_string(key: Int64) -> Bool:
        return seq_free_string_in_cache(key)


@value
@register_passable
struct CString:
    var data: c_char_ptr
    var len: Int

    fn data_u8(self) -> UnsafePointer[SIMD[DType.uint8, 1]]:
        return rebind[UnsafePointer[SIMD[DType.uint8, 1]]](self.data)


@value
struct MyStringCache:
    var _keys: List[Int64]

    fn __init__(inout self):
        self._keys = List[Int64]()

    fn __del__(owned self):
        for key in self._keys:
            _ = StringCache.free_string(key[])

    fn set_string(inout self, s: String) -> CString:
        var r = StringCache.set_string(s)
        var key = r.get[0, Int64]()
        var result = r.get[1, CString]()
        self._keys.append(key)
        return result
