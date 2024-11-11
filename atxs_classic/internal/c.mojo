from memory import memcpy, memset_zero, UnsafePointer
from sys.ffi import external_call
from sys.ffi import c_char, c_size_t, c_long
from utils import StringRef


fn strlen(s: UnsafePointer[c_char]) -> c_size_t:
    """
    :strlen libc POSIX `strlen` function
    Reference: https://man7.org/linux/man-pages/man3/strlen.3p.html
    Fn signature: size_t strlen(const char *s).
    Args:
    s
    Returns:
    .
    """
    return external_call["strlen", c_size_t, UnsafePointer[c_char]](s)


fn strlen(s: UnsafePointer[c_uchar]) -> c_size_t:
    """
    :strlen libc POSIX `strlen` function
    Reference: https://man7.org/linux/man-pages/man3/strlen.3p.html
    Fn signature: size_t strlen(const char *s).
    Args:
    s
    Returns:
    .
    """
    return external_call["strlen", c_size_t, UnsafePointer[c_uchar]](s)


fn c_str_to_string(s: UnsafePointer[UInt8], n: Int) -> String:
    var size = n + 1
    var ptr = UnsafePointer[UInt8]().alloc(size)
    memset_zero(ptr.offset(n), 1)
    memcpy(ptr, s, n)
    return String(ptr=ptr, length=size)


fn c_str_to_string_view(s: UnsafePointer[c_uchar]) -> String:
    return String(ptr=s, length=strlen(s))


fn c_str_to_string_view(s: UnsafePointer[c_char]) -> String:
    return String(ptr=s, length=strlen(s))


fn c_str_to_string_view(s: UnsafePointer[UInt8], n: Int) -> String:
    return String(ptr=s, length=n)
