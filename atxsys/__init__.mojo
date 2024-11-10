from memory import UnsafePointer
from sys.ffi import c_char, c_size_t
from .c import *
from .eh import *
from .log import *
from .fixed import Fixed
from .ssmap import SSMap
from .hmac import hmac_sha256_hex, hmac_sha512_hex
from .sha512 import sha512_hex
# from .sonic import SonicDocument, SonicNode


alias c_uchar = UInt8
alias c_void = UInt8
alias c_double = Float64
alias c_char_ptr = UnsafePointer[c_char]
alias c_void_ptr = UnsafePointer[c_void]
alias c_nullptr = c_void_ptr()

alias LIBNAME = "libatx.so"
