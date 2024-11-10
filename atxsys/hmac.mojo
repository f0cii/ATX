from memory import UnsafePointer
from collections.vector import InlinedFixedVector


fn hmac_sha256_hex(message: String, secret_key: String) -> String:
    """
    计算给定消息和密钥的 HMAC-SHA256 哈希值，并返回其十六进制表示.

    参数:
        message (String): 要加密的消息
        secret_key (String): 用于加密的密钥

    返回:
        String: HMAC-SHA256 哈希值的十六进制表示.
    """
    var b_ptr = UnsafePointer[UInt8].alloc(32)
    var n = seq_hmac_sha256(
        secret_key.unsafe_cstr_ptr(),
        len(secret_key),
        message.unsafe_cstr_ptr(),
        len(message),
        b_ptr,
    )
    var s_ptr = UnsafePointer[UInt8].alloc(65)
    var s_len = seq_hex_encode(b_ptr, n, s_ptr)
    # var s = c_str_to_string(s_ptr, s_len)
    var s = String(s_ptr, s_len + 1)

    b_ptr.free()
    # s_ptr.free()

    return s


fn hmac_sha512_hex(message: String, secret_key: String) -> String:
    """
    计算给定消息和密钥的 HMAC-SHA512 哈希值，并返回其十六进制表示.

    参数:
        message (String): 要加密的消息
        secret_key (String): 用于加密的密钥

    返回:
        String: HMAC-SHA512 哈希值的十六进制表示.
    """
    var b_ptr = UnsafePointer[UInt8].alloc(64)  # 32
    var n = seq_hmac_sha512(
        secret_key.unsafe_cstr_ptr(),
        len(secret_key),
        message.unsafe_cstr_ptr(),
        len(message),
        b_ptr,
    )
    var s_ptr = UnsafePointer[UInt8].alloc(129)  # 65
    var s_len = seq_hex_encode(b_ptr, n, s_ptr)
    # var s = c_str_to_string(s_ptr, s_len)
    var s = String(s_ptr, s_len + 1)

    b_ptr.free()
    # s_ptr.free()

    return s


fn to_hex_string(digest: InlinedFixedVector[UInt8, 32]) -> String:
    var lookup = String("0123456789abcdef")
    var result: String = ""
    for i in range(len(digest)):
        var v = int(digest[i])
        result += lookup[(v >> 4)]
        result += lookup[v & 15]

    return result