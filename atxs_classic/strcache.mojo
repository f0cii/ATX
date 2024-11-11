from collections.list import List
from .internal.strcache import *


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
