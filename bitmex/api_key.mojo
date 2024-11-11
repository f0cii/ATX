from memory import UnsafePointer
from atxs import now_ms, now_ns
from atxs_classic.hmac import hmac_sha256_hex


fn generate_nonce() -> Int:
    return int(round(now_ms() / 1000 + 3600))


# Generates an API signature.
# A signature is HMAC_SHA256(secret, verb + path + nonce + data), hex encoded.
# Verb must be uppercased, url is relative, nonce must be an increasing 64-bit integer
# and the data, if present, must be JSON without whitespace between keys.
#
# For example, in psuedocode (and in real code below):
#
# verb=POST
# url=/api/v1/order
# nonce=1416993995705
# data={"symbol":"XBTZ14","quantity":1,"price":395.01}
# signature = HEX(HMAC_SHA256(secret, 'POST/api/v1/order1416993995705{"symbol":"XBTZ14","quantity":1,"price":395.01}'))
fn generate_signature(
    secret: String, verb: String, url: String, nonce: Int, data: String
) -> String:
    # """Generate a request signature compatible with BitMEX."""
    # # Parse the url so we can remove the base and extract just the path.
    # parsedURL = urllib.parse.urlparse(url)
    # path = parsedURL.path
    # if parsedURL.query:
    #     path = path + '?' + parsedURL.query

    # # print "Computing HMAC: %s" % verb + path + str(nonce) + data
    # message = (verb + path + str(nonce) + data).encode('utf-8')

    # signature = hmac.new(secret.encode('utf-8'), message, digestmod=hashlib.sha256).hexdigest()
    # return signature
    var message = verb + url + str(nonce) + data
    return hmac_sha256_hex(message, secret)
