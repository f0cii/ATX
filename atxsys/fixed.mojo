from sys import external_call
from sys.ffi import DLHandle
from .c import *


alias FIXED_SCALE_I = 1000000000000
alias FIXED_SCALE_F = 1000000000000.0


var _fw = _FixedWrapper()


@value
struct _FixedWrapper:
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
    return _fw._seq_fixed12_new_string.call(cstr, cstr_len)


@always_inline
fn seq_fixed12_to_string(fixed: Int64, result: c_void_ptr) -> c_size_t:
    return _fw._seq_fixed12_to_string.call(fixed, result)


@always_inline
fn seq_fixed_mul(a: Int64, b: Int64) -> Int64:
    return _fw._seq_fixed_mul.call(a, b)


@always_inline
fn seq_fixed_truediv(a: Int64, b: Int64) -> Int64:
    return _fw._seq_fixed_truediv.call(a, b)


@always_inline
fn seq_fixed_round_to_fractional(a: Int64, scale: Int64) -> Int64:
    return _fw._seq_fixed_round_to_fractional.call(a, scale)


@always_inline
fn seq_fixed_round(a: Int64, decimal_places: Int) -> Int64:
    return _fw._seq_fixed_round.call(a, decimal_places)


@value
@register_passable
struct Fixed(Stringable):
    alias zero = Fixed(0)
    alias one = Fixed(1)
    alias two = Fixed(2)
    alias three = Fixed(3)
    alias four = Fixed(4)
    alias five = Fixed(5)
    alias six = Fixed(6)
    alias seven = Fixed(7)
    alias eight = Fixed(8)
    alias nine = Fixed(9)
    alias ten = Fixed(10)

    var _value: Int64

    fn __init__(inout self):
        self._value = 0

    fn __init__(inout self, v: Int):
        self._value = FIXED_SCALE_I * v

    fn __init__(inout self, v: Float64):
        self._value = Int64(int(v * FIXED_SCALE_F))

    fn __init__(inout self, v: String):
        var v_ = seq_fixed12_new_string(v.unsafe_cstr_ptr(), len(v))
        self._value = v_

    fn copy_from(inout self, other: Self):
        self._value = other._value

    @staticmethod
    fn from_value(value: Int64) -> Self:
        return Self {
            _value: value,
        }

    @always_inline
    fn is_zero(self) -> Bool:
        return self._value == 0

    @always_inline
    fn value(self) -> Int64:
        return self._value

    @always_inline
    fn to_int(self) -> Int:
        return int(self._value / FIXED_SCALE_I)

    @always_inline
    fn to_float(self) -> Float64:
        return self._value.cast[DType.float64]() / FIXED_SCALE_F

    @always_inline
    fn to_string(self) -> String:
        # TODO: 使用申请的内存直接构建String对象
        var ptr = UnsafePointer[c_uchar].alloc(17)
        var n = seq_fixed12_to_string(self._value, ptr)
        var s = c_str_to_string(ptr, n)
        ptr.free()
        return s

    @always_inline
    fn round_to_fractional(self, scale: Int) -> Self:
        var v = seq_fixed_round_to_fractional(self._value, scale)
        return Self {
            _value: v,
        }

    @always_inline
    fn round(self, decimal_places: Int) -> Self:
        var v = seq_fixed_round(self._value, decimal_places)
        return Self {
            _value: v,
        }

    @always_inline
    fn abs(self) -> Self:
        var v = -self._value if self._value < 0 else self._value
        return Self {_value: v}

    fn __eq__(self, other: Self) -> Bool:
        return self._value == other._value

    fn __ne__(self, other: Self) -> Bool:
        return self._value != other._value

    fn __lt__(self, other: Self) -> Bool:
        return self._value < other._value

    fn __le__(self, other: Self) -> Bool:
        return self._value <= other._value

    fn __gt__(self, other: Self) -> Bool:
        return self._value > other._value

    fn __ge__(self, other: Self) -> Bool:
        return self._value >= other._value

    # Customizing negation
    fn __neg__(self) -> Self:
        return Self {_value: -self._value}

    # Customizing addition
    fn __add__(self, other: Self) -> Self:
        return Self {_value: self._value + other._value}

    # Customizing +=
    fn __iadd__(inout self, other: Self):
        self._value += other._value

    # Customizing subtraction
    fn __sub__(self, other: Self) -> Self:
        return Self {_value: self._value - other._value}

    # Customizing -=
    fn __isub__(inout self, other: Self):
        self._value -= other._value

    # Customizing multiplication
    fn __mul__(self, other: Self) -> Self:
        var v = seq_fixed_mul(self._value, other._value)
        return Self {_value: v}

    # Customizing *=
    fn __imul__(inout self, other: Self):
        self._value = seq_fixed_mul(self._value, other._value)

    # Customizing division
    fn __truediv__(self, other: Self) -> Self:
        var v = seq_fixed_truediv(self._value, other._value)
        return Self {_value: v}

    # Customizing /=
    fn __itruediv__(inout self, other: Self):
        self._value = seq_fixed_truediv(self._value, other._value)

    fn __str__(self) -> String:
        return self.to_string()
