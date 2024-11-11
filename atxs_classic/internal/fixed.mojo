from sys import external_call
from sys.ffi import DLHandle
from .c import *


alias FIXED_SCALE_I = 1000000000000
alias FIXED_SCALE_F = 1000000000000.0


var __wrapper = _DLWrapper()


@value
struct _DLWrapper:
    var _handle: DLHandle

    var _seq_fixed12_new_string: DL_Fn[
        "seq_fixed12_new_string",
        fn (cstr: c_char_ptr, cstr_len: c_size_t) -> Int64,
    ]
    var _seq_fixed12_to_string: DL_Fn[
        "seq_fixed12_to_string",
        fn (fixed: Int64, result: c_void_ptr) -> c_size_t,
    ]
    # Customize multiplication operation
    var _seq_fixed_mul: DL_Fn["seq_fixed_mul", fn (a: Int64, b: Int64) -> Int64]
    # Customize division operation
    var _seq_fixed_truediv: DL_Fn[
        "seq_fixed_truediv", fn (a: Int64, b: Int64) -> Int64
    ]
    var _seq_fixed_round_to_fractional: DL_Fn[
        "seq_fixed_round_to_fractional", fn (a: Int64, scale: Int64) -> Int64
    ]
    var _seq_fixed_round: DL_Fn[
        "seq_fixed_round", fn (a: Int64, decimalPlaces: Int) -> Int64
    ]

    fn __init__(inout self):
        self._handle = DLHandle(LIBNAME)
        self._seq_fixed12_new_string = self._handle
        self._seq_fixed12_to_string = self._handle
        self._seq_fixed_mul = self._handle
        self._seq_fixed_truediv = self._handle
        self._seq_fixed_round_to_fractional = self._handle
        self._seq_fixed_round = self._handle

        # var i = str(self._handle.handle.bitcast[UInt8]())
        # print("_FixedWrapper i=" + str(i))


@always_inline
fn seq_fixed12_new_string(cstr: c_char_ptr, cstr_len: c_size_t) -> Int64:
    return __wrapper._seq_fixed12_new_string.call(cstr, cstr_len)


@always_inline
fn seq_fixed12_to_string(fixed: Int64, result: c_void_ptr) -> c_size_t:
    return __wrapper._seq_fixed12_to_string.call(fixed, result)


@always_inline
fn seq_fixed_mul(a: Int64, b: Int64) -> Int64:
    return __wrapper._seq_fixed_mul.call(a, b)


@always_inline
fn seq_fixed_truediv(a: Int64, b: Int64) -> Int64:
    return __wrapper._seq_fixed_truediv.call(a, b)


@always_inline
fn seq_fixed_round_to_fractional(a: Int64, scale: Int64) -> Int64:
    return __wrapper._seq_fixed_round_to_fractional.call(a, scale)


@always_inline
fn seq_fixed_round(a: Int64, decimal_places: Int) -> Int64:
    return __wrapper._seq_fixed_round.call(a, decimal_places)
