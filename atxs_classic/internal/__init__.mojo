from memory import UnsafePointer
from sys.ffi import c_char, c_size_t
from .c import *
from .ffi import *
from .fixed import *
from .orderbook import *
from .strcache import *
from .base import *
from .photon import *
from .consts import *

# alias c_uchar = UInt8
# alias c_void = UInt8
# alias c_double = Float64
# alias c_char_ptr = UnsafePointer[c_char]
# alias c_void_ptr = UnsafePointer[c_void]
# alias c_nullptr = c_void_ptr()

# alias LIBNAME = "libatx-classic.so"
