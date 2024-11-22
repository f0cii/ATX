from memory import UnsafePointer
from sys.ffi import DLHandle
from sys.ffi import c_char, c_size_t
from utils import StringRef
from sys import os_is_macos


alias c_bool = Bool
alias c_char_ptr = UnsafePointer[c_char]
alias c_float = Float32
alias c_double = Float64
alias c_int = Int
alias c_uint = UInt
alias c_int8 = Int8
alias c_uint8 = UInt8
alias c_int16 = Int16
alias c_uint16 = UInt16
alias c_int32 = Int32
alias c_int64 = Int64
alias c_uchar = UInt8
alias c_uint32 = UInt32
alias c_uint64 = UInt64
alias c_void = UInt8
alias c_void_ptr = UnsafePointer[c_void]
alias c_nullptr = c_void_ptr()


# os platform:
fn get_libname() -> StringLiteral:
    @parameter
    if os_is_macos():
        return "libatx-classic.dylib"
    else:
        return "libatx-classic.so"


alias LIBNAME = get_libname()