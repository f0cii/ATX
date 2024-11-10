# https://github.com/GTXV/simple_bitmex_api/blob/main/example.py
import hashlib
import time
from base.time_util import now_ms, now_ns
from atxsys.httpclient import HttpClient, Headers
from atxsys.hmac import hmac_sha256_hex
from atxsys.sonic import SonicDocument
from atxsys import *


alias METHOD_GET = "GET"
alias METHOD_POST = "POST"
alias METHOD_PUT = "PUT"
alias METHOD_DELETE = "DELETE"


struct BitMEXClient:
    var api_key: String
    var api_secret: String
    var base_url: String
    var client: HttpClient

    fn __init__(
        inout self, api_key: String, api_secret: String, base_url: String
    ):
        self.api_key = api_key
        self.api_secret = api_secret
        self.base_url = base_url
        logi("self.baes_url=" + self.base_url)
        self.client = HttpClient(self.base_url)
        self.client.set_verbose(True)

    fn generate_signature(
        self,
        apisecret: String,
        verb: String,
        url: String,
        expires: Int,
        data: String,
    ) -> String:
        var message = verb + url + str(expires) + data
        var signature = hmac_sha256_hex(message, apisecret)
        return signature

    fn _get_headers(self, url: String, data: String, method: String) -> Headers:
        # data = json.dumps(postdict)
        var expires = int(now_ms() / 1000 + 3)
        var headers = Headers()
        # var header = {'api-expires': str(expires),'api-key':self.apiKey,'api-signature':self.generate_signature(self.apiSecret, method, url, expires, data)}
        headers["content-type"] = "application/json"
        headers["api-expires"] = str(expires)
        headers["api-key"] = self.api_key
        headers["api-signature"] = self.generate_signature(
            self.api_secret, method, url, expires, data
        )
        return headers^

    fn place_order(
        self, symbol: String, orderQty: String, price: String, side: String
    ) raises -> String:
        # {"symbol": "XBTUSDT", "orderQty": "1000", "price": "10000", "side": "Buy"}
        var path = "/api/v1/order"
        var doc = SonicDocument()
        doc.add_string("symbol", symbol)
        doc.add_string("orderQty", orderQty)
        doc.add_string("price", price)
        doc.add_string("side", side)
        var payload = doc.to_string()
        # logi("payload=" + payload)
        
        var headers = self._get_headers(path, payload, METHOD_POST)
        var re = self.client.post(path, payload=payload, headers=headers)
        # {"orderID":"2216e80d-ed81-4803-9703-6e6c24d79872","account":137087,"symbol":"XBTUSDT","side":"Buy","orderQty":1000,"price":10000,"displayQty":null,"stopPx":null,"pegOffsetValue":null,"pegPriceType":"","currency":"USDT","settlCurrency":"USDt","ordType":"Limit","timeInForce":"GoodTillCancel","execInst":"","exDestination":"","ordStatus":"New","triggered":"","workingIndicator":true,"ordRejReason":"","leavesQty":1000,"cumQty":0,"avgPx":null,"text":"Submitted via API.","transactTime":"2024-10-11T03:09:48.839Z","timestamp":"2024-10-11T03:09:48.840Z"}
        return re.text

    # def amend_order(self, postdict):
    #     var path = self.base_url + "/order"
    #     var header = self.get_header("/api/v1/order", postdict, 'PUT')
    #     var re = self.s.put(path, json=postdict, headers=header)
    #     return re.json()

    # def cancel_order(self, postdict):
    #     var path = self.base_url + "/order"
    #     var header = self.get_header("/api/v1/order", postdict, 'DELETE')
    #     var re = self.s.delete(path, json=postdict, headers=header)
    #     return re.json()

    # def get_depth(self, postdict):
    #     var path = self.base_url + "/orderBook/L2"
    #     var header = self.get_header("/api/v1/orderBook/L2", postdict, 'GET')
    #     var re = requests.get(path, json=postdict, headers=header)
    #     return re

    # def set_leverage(self, postdict):
    #     var path = self.base_url + "/position/leverage"
    #     var header = self.get_header("/api/v1/position/leverage", postdict, 'POST')
    #     var re = self.s.post(path, json=postdict, headers=header)
    #     return re


fn tset_bitmex_api() raises:
    var api_key = "1mCElmfIRxSfPwYfIhJlF8Wi"
    var api_secret = "K620ZiIAEW3fxenAeB0l_hVizwbYYncqqQB2HqcFS-Sw6ZLq"
    var base_url = "https://testnet.bitmex.com"
    var ex = BitMEXClient(api_key, api_secret, base_url)

    # var postdict_buy = {"symbol": "XBTUSDT", "orderQty": "1000", "price": "10000", "side": "Buy"}

    var st = now_ns()
    var symbol = "XBTUSDT"
    var orderQty = "1000"
    var price = "10000"
    var side = "Buy"
    var re1 = ex.place_order(symbol, orderQty, price, side)  # .text
    print(now_ns() - st)
    print(re1)
