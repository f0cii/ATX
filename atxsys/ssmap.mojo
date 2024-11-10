import sys
from memory import UnsafePointer
from .c import (
    c_str_to_string,
)


struct SSMap:
    var ptr: c_void_ptr

    fn __init__(inout self):
        self.ptr = seq_ssmap_new()

    fn __del__(owned self):
        seq_ssmap_free(self.ptr)

    fn __moveinit__(inout self, owned existing: Self):
        self.ptr = existing.ptr

    fn __setitem__(inout self, key: String, value: String):
        seq_ssmap_set(
            self.ptr,
            key.unsafe_cstr_ptr(),
            value.unsafe_cstr_ptr(),
        )

    fn __getitem__(self, key: String) -> String:
        var n: c_size_t = 0
        var s = seq_ssmap_get(
            self.ptr,
            key.unsafe_cstr_ptr(),
            UnsafePointer[c_size_t].address_of(n),
        )
        return c_str_to_string(s, n)

    fn __len__(self) -> Int:
        return seq_ssmap_size(self.ptr)
