# alias SHA512_DIGEST_LENGTH = 64


fn sha512_hex(text: String) -> String:
    var b_ptr = UnsafePointer[UInt8].alloc(SHA512_DIGEST_LENGTH)
    var n = seq_sha512(
        text.unsafe_cstr_ptr(),
        len(text),
        b_ptr,
    )
    var s_ptr = UnsafePointer[UInt8].alloc(SHA512_DIGEST_LENGTH + 1)
    var s_len = seq_hex_encode(b_ptr, n, s_ptr)
    var s = String(s_ptr, s_len + 1)

    b_ptr.free()

    return s
