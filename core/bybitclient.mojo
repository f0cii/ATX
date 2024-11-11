from collections.list import List
from atxs_classic import *
from atxs_classic.httpclient import *

from .bybitmodel import (
    ServerTime,
    ExchangeInfo,
    KlineItem,
    OrderBookItem,
    OrderBook,
    OrderResponse,
    BalanceInfo,
    OrderInfo,
)
from .models import PositionInfo
from atxs_classic.hmac import hmac_sha256_hex
from atxs import now_ms, now_ns
from sonic import *


struct BybitClient:
    var testnet: Bool
    var access_key: String
    var secret_key: String
    var client: HttpClient

    fn __init__(
        inout self, testnet: Bool, access_key: String, secret_key: String
    ):
        # print(base_url)
        self.testnet = testnet
        self.access_key = access_key
        self.secret_key = secret_key
        var base_url = "https://api-testnet.bybit.com" if self.testnet else "https://api.bybit.com"
        self.client = HttpClient(base_url, tlsv13_client)

    fn __moveinit__(inout self, owned existing: Self):
        logd("BybitClient.__moveinit__")
        self.testnet = existing.testnet
        self.access_key = existing.access_key
        self.secret_key = existing.secret_key
        var base_url = "https://api-testnet.bybit.com" if self.testnet else "https://api.bybit.com"
        self.client = existing.client^
        logd("BybitClient.__moveinit__ done")

    fn set_verbose(inout self, verbose: Bool):
        self.client.set_verbose(verbose)

    fn fetch_public_time(self) raises -> ServerTime:
        var ret = self.do_get("/v3/public/time", "", False)
        if ret.status_code != 200:
            raise Error("error status_code=" + str(ret.status_code))

        # print(ret.body)
        logd("text: " + str(ret.text))

        # {"retCode":0,"retMsg":"OK","result":{"timeSecond":"1696233582","timeNano":"1696233582169993116"},"retExtInfo":{},"time":1696233582169}
        var doc = JsonObject(ret.text)
        var ret_code = doc.get_i64("retCode")
        var ret_msg = doc.get_str("retMsg")
        if ret_code != 0:
            raise Error(
                "error retCode=" + str(ret_code) + ", retMsg=" + str(ret_msg)
            )

        var result = doc.get_object_mut("result")

        var time_second = atol(result.get_str("timeSecond"))
        var time_nano = atol(result.get_str("timeNano"))

        return ServerTime(time_second, time_nano)

    fn fetch_exchange_info(
        self, category: String, symbol: String
    ) raises -> ExchangeInfo:
        var query_values = QueryParams()
        query_values["category"] = category
        query_values["symbol"] = symbol
        var query_str = query_values.to_string()
        # logi("query_str: " + query_str)
        var ret = self.do_get("/v5/market/instruments-info", query_str, False)
        if ret.status_code != 200:
            raise Error("error status_code=" + str(ret.status_code))

        logd(ret.text)

        # {"retCode":0,"retMsg":"OK","result":{"category":"linear","list":[{"symbol":"BTCUSDT","contractType":"LinearPerpetual","status":"Trading","baseCoin":"BTC","quoteCoin":"USDT","launchTime":"1584230400000","deliveryTime":"0","deliveryFeeRate":"","priceScale":"2","leverageFilter":{"minLeverage":"1","maxLeverage":"100.00","leverageStep":"0.01"},"priceFilter":{"minPrice":"0.10","maxPrice":"199999.80","tickSize":"0.10"},"lotSizeFilter":{"maxOrderQty":"100.000","minOrderQty":"0.001","qtyStep":"0.001","postOnlyMaxOrderQty":"1000.000"},"unifiedMarginTrade":true,"fundingInterval":480,"settleCoin":"USDT","copyTrading":"both"}],"nextPageCursor":""},"retExtInfo":{},"time":1701762078208}

        var tick_size: Fixed = Fixed.zero
        var step_size: Fixed = Fixed.zero
        var min_order_qty: Fixed = Fixed.zero
        var min_notional_value: Fixed = Fixed.zero

        var doc = JsonObject(ret.text)
        var ret_code = doc.get_i64("retCode")
        var ret_msg = doc.get_str("retMsg")
        if ret_code != 0:
            raise Error(
                "error retCode=" + str(ret_code) + ", retMsg=" + str(ret_msg)
            )

        var result = doc.get_object_mut("result")
        var category_ = result.get_str("category")
        var result_list = result.get_array_mut("list")
        if result_list.len() == 0:
            raise Error("error list length is 0")

        var list_iter = result_list.iter()

        while True:
            var value = list_iter.next()
            if value.is_null():
                break
            var obj = value.as_object_ref()
            var symbol_ = obj.get_str("symbol")
            # if symbol.upper() != symbol_.upper():
            # logd("symbol_: " + symbol_ + " symbol: " + symbol)
            if str(symbol) != symbol_:
                # logd("not eq")
                continue

            if category_ == "linear":
                var priceFilter = obj.get_object_ref("priceFilter")
                tick_size = Fixed(priceFilter.get_str("tickSize"))
                var lotSizeFilter = obj.get_object_ref("lotSizeFilter")
                step_size = Fixed(lotSizeFilter.get_str("qtyStep"))
                min_order_qty = Fixed(lotSizeFilter.get_str("minOrderQty"))
                min_notional_value = Fixed(
                    lotSizeFilter.get_str("minNotionalValue")
                )
            elif category_ == "spot":
                """
                    {
                    "symbol": "USDCUSDT",
                    "baseCoin": "USDC",
                    "quoteCoin": "USDT",
                    "innovation": "0",
                    "status": "Trading",
                    "marginTrading": "both",
                    "lotSizeFilter": {
                        "basePrecision": "0.01",
                        "quotePrecision": "0.000001",
                        "minOrderQty": "1",
                        "maxOrderQty": "2496045.89",
                        "minOrderAmt": "1",
                        "maxOrderAmt": "2000000"
                    },
                    "priceFilter": {
                        "tickSize": "0.0001"
                    },
                    "riskParameters": {
                        "limitParameter": "0.01",
                        "marketParameter": "0.01"
                    }
                }
                """
                var lotSizeFilter = obj.get_object_ref("lotSizeFilter")
                step_size = Fixed(lotSizeFilter.get_str("basePrecision"))
                min_order_qty = Fixed(lotSizeFilter.get_str("minOrderQty"))
                min_notional_value = Fixed(lotSizeFilter.get_str("minOrderAmt"))
                var priceFilter = obj.get_object_ref("priceFilter")
                tick_size = Fixed(priceFilter.get_str("tickSize"))

            # logi("tick_size: " + str(tick_size))
            # logi("stepSize: " + str(stepSize))

        return ExchangeInfo(
            symbol, tick_size, min_order_qty, step_size, min_notional_value
        )

    fn fetch_kline(
        self,
        category: String,
        symbol: String,
        interval: String,
        limit: Int,
        start: Int,
        end: Int,
    ) raises -> List[KlineItem]:
        var query_values = QueryParams()
        query_values["category"] = category
        query_values["symbol"] = symbol
        query_values["interval"] = interval
        if limit > 0:
            query_values["limit"] = str(limit)
        if start > 0:
            query_values["start"] = str(start)
        if end > 0:
            query_values["end"] = str(end)
        var query_str = query_values.to_string()
        var ret = self.do_get("/v5/market/kline", query_str, False)
        if ret.status_code != 200:
            raise Error("error status_code=" + str(ret.status_code))

        # logi(ret.body)
        # {"retCode":0,"retMsg":"OK","result":{"symbol":"BTCUSDT","category":"linear","list":[["1687589640000","30709.9","30710.4","30709.9","30710.3","3.655","112245.7381"],["1687589580000","30707.9","30710","30704.7","30709.9","21.984","675041.8648"],["1687589520000","30708","30714.7","30705","30707.9","33.378","1025097.6459"],["1687589460000","30689.9","30710.3","30689.9","30708","51.984","1595858.2778"],["1687589400000","30678.6","30690.9","30678.5","30689.9","38.747","1188886.4093"]]},"retExtInfo":{},"time":1687589659062}

        var res = List[KlineItem]()

        var doc = JsonObject(ret.text)
        var ret_code = doc.get_i64("retCode")
        var ret_msg = doc.get_str("retMsg")
        if ret_code != 0:
            raise Error(
                "error retCode=" + str(ret_code) + ", retMsg=" + ret_msg
            )

        var result = doc.get_object_mut("result")
        var result_list = result.get_array_mut("list")

        var list_iter = result_list.iter()

        while True:
            var value = list_iter.next()
            if value.is_null():
                break
            var i_arr_list = value.as_array_ref()

            var timestamp = int(i_arr_list.get_str(0))
            var open_ = float(i_arr_list.get_str(1))
            var high = float(i_arr_list.get_str(2))
            var low = float(i_arr_list.get_str(3))
            var close = float(i_arr_list.get_str(4))
            var volume = float(i_arr_list.get_str(5))
            var turnover = float(i_arr_list.get_str(6))

            res.append(
                KlineItem(
                    timestamp=timestamp,
                    open=open_,
                    high=high,
                    low=low,
                    close=close,
                    volume=volume,
                    turnover=turnover,
                    confirm=True,
                )
            )

        return res

    fn fetch_orderbook(
        self, category: String, symbol: String, limit: Int
    ) raises -> OrderBook:
        var query_values = QueryParams()
        query_values["category"] = category
        query_values["symbol"] = symbol
        if limit > 0:
            query_values["limit"] = str(limit)
        var query_str = query_values.to_string()
        var ret = self.do_get("/v5/market/orderbook", query_str, False)
        if ret.status_code != 200:
            raise Error("error status_code=" + str(ret.status_code))

        # print(ret.body)
        # {
        #     "result": {
        #         "a": [["30604.8", "174.267"], ["30648.6", "0.002"], ["30649.1", "0.001"], ["30650", "1.119"], ["30650.3", "0.01"], ["30650.8", "0.001"], ["30651.6", "0.001"], ["30652", "0.001"], ["30652.4", "0.062"], ["30652.5", "0.001"]],
        #         "b": [["30598.7", "142.31"], ["30578.2", "0.004"], ["30575.3", "0.001"], ["30571.8", "0.001"], ["30571.1", "0.002"], ["30568.5", "0.002"], ["30566.6", "0.005"], ["30565.6", "0.01"], ["30565.5", "0.061"], ["30563", "0.001"]],
        #         "s": "BTCUSDT",
        #         "ts": 1689132447413,
        #         "u": 5223166
        #     },
        #     "retCode": 0,
        #     "retExtInfo": {},
        #     "retMsg": "OK",
        #     "time": 1689132448224
        # }

        # res = OrderBook
        var asks = List[OrderBookItem]()
        var bids = List[OrderBookItem]()

        var doc = JsonObject(ret.text)
        var ret_code = doc.get_i64("retCode")
        var ret_msg = doc.get_str("retMsg")
        if ret_code != 0:
            raise Error(
                "error retCode=" + str(ret_code) + ", retMsg=" + ret_msg
            )

        var result = doc.get_object_mut("result")
        var a_list = result.get_array_mut("a")

        var list_iter_a = a_list.iter()

        while True:
            var value = list_iter_a.next()
            if value.is_null():
                break
            var i_arr_list = value.as_array_ref()

            var price = i_arr_list.get_str(0)
            var qty = i_arr_list.get_str(1)

            asks.append(OrderBookItem(price, qty))

        var b_list = result.get_array_mut("b")

        var list_iter_b = b_list.iter()

        while True:
            var value = list_iter_b.next()
            if value.is_null():
                break
            var i_arr_list = value.as_array_ref()

            var price = i_arr_list.get_str(0)
            var qty = i_arr_list.get_str(1)

            bids.append(OrderBookItem(price, qty))

        return OrderBook(asks, bids)

    fn switch_position_mode(
        self, category: String, symbol: String, mode: String
    ) raises -> Bool:
        """
        Switch position mode
        mode: 0-PositionModeMergedSingle 3-PositionModeBothSides
        """
        var post_doc = JsonObject()
        post_doc.insert_str("category", category)
        post_doc.insert_str("symbol", symbol)
        post_doc.insert_str("mode", mode)
        var body_str = post_doc.to_string()

        # logi("body=" + body_str)
        # {"category":"linear","symbol":"BTCUSDT","mode":"0"}
        var ret = self.do_post("/v5/position/switch-mode", body_str, True)
        # print(ret)
        if ret.status_code != 200:
            raise Error("error status_code=" + str(ret.status_code))
        # /*

        # * {"retCode":10001,"retMsg":"params error: position_mode invalid","result":{},"retExtInfo":{},"time":1687601751714}
        # * {"retCode":110025,"retMsg":"Position mode is not modified","result":{},"retExtInfo":{},"time":1687601811928}
        # * {"retCode":0,"retMsg":"OK","result":{},"retExtInfo":{},"time":1687601855987}
        # * {"retCode":110025,"retMsg":"Position mode is not modified","result":{},"retExtInfo":{},"time":1696337560088}
        # */

        # logi(ret.body)

        var doc = JsonObject(ret.text)
        var ret_code = doc.get_i64("retCode")
        var ret_msg = doc.get_str("retMsg")
        if ret_code != 0:
            raise Error(
                "error retCode=" + str(ret_code) + ", retMsg=" + ret_msg
            )

        return True

    fn set_leverage(
        self,
        category: String,
        symbol: String,
        buy_leverage: String,
        sell_leverage: String,
    ) raises -> Bool:
        """
        Set leverage multiplier
        """
        var post_doc = JsonObject()
        post_doc.insert_str("category", category)
        post_doc.insert_str("symbol", symbol)
        post_doc.insert_str("buyLeverage", buy_leverage)
        post_doc.insert_str("sellLeverage", sell_leverage)
        var body_str = post_doc.to_string()

        # print(body_str)

        var ret = self.do_post("/v5/position/set-leverage", body_str, True)
        # print(ret)
        if ret.status_code != 200:
            raise Error("error status_code=" + str(ret.status_code))

        # /*
        # * {"retCode":0,"retMsg":"OK","result":{},"retExtInfo":{},"time":1696339881214}
        # * {"retCode":110043,"retMsg":"Set leverage not modified","result":{},"retExtInfo":{},"time":1696339921712}
        # * {"retCode":110043,"retMsg":"Set leverage not modified","result":{},"retExtInfo":{},"time":1701874812321}
        # */

        var doc = JsonObject(ret.text)
        var ret_code = doc.get_i64("retCode")
        var ret_msg = doc.get_str("retMsg")
        if ret_code != 0:
            raise Error(
                "error retCode=" + str(ret_code) + ", retMsg=" + ret_msg
            )

        return True

    fn place_order(
        self,
        category: String,
        symbol: String,
        side: String,
        order_type: String,
        qty: String,
        price: String,
        time_in_force: String = "",
        position_idx: Int = 0,
        order_link_id: String = "",
        reduce_only: Bool = False,
        is_leverage: Int = -1,
    ) raises -> OrderResponse:
        """
        Place an order.
        is_leverage:	false	integer	是否借貸. 僅統一帳戶的現貨交易有效. 0(default): 否，則是幣幣訂單, 1: 是，則是槓桿訂單.
        """
        var post_doc = JsonObject()
        post_doc.insert_str("category", category)
        post_doc.insert_str("symbol", symbol)
        post_doc.insert_str("side", side)
        post_doc.insert_str("orderType", order_type)
        post_doc.insert_str("qty", qty)
        if price != "":
            post_doc.insert_str("price", price)
        if time_in_force != "":
            post_doc.insert_str("timeInForce", time_in_force)
        if position_idx != 0:
            post_doc.insert_str("positionIdx", str(position_idx))
        if order_link_id != "":
            post_doc.insert_str("orderLinkId", order_link_id)
        if reduce_only:
            post_doc.insert_str("reduceOnly", "true")
        if is_leverage != -1:
            post_doc.insert_i64("isLeverage", is_leverage)
        var body_str = post_doc.to_string()

        # print(body_str)

        var ret = self.do_post("/v5/order/create", body_str, True)
        # print(ret)
        if ret.status_code != 200:
            raise Error("error status_code=" + str(ret.status_code))

        # * {"retCode":10001,"retMsg":"params error: side invalid","result":{},"retExtInfo":{},"time":1687610278834}
        # * {"retCode":10001,"retMsg":"position idx not match position mode","result":{},"retExtInfo":{},"time":1687610314417}
        # * {"retCode":10001,"retMsg":"The number of contracts exceeds minimum limit allowed","result":{},"retExtInfo":{},"time":1687610435384}
        # * {"retCode":110003,"retMsg":"Order price is out of permissible range","result":{},"retExtInfo":{},"time":1687610383879}
        # * {"retCode":110017,"retMsg":"Reduce-only rule not satisfied","result":{},"retExtInfo":{},"time":1689175546336}
        # * {"retCode":0,"retMsg":"OK","result":{"orderId":"b719e004-0846-4b58-8405-a307133c5146","orderLinkId":""},"retExtInfo":{},"time":1689176180262}
        # * {"retCode":0,"retMsg":"OK","result":{"orderId":"44ce1d85-3458-4ec3-af76-41a4cf80c9b3","orderLinkId":""},"retExtInfo":{},"time":1696404669448}

        # print(ret.body)
        var doc = JsonObject(ret.text)
        var ret_code = doc.get_i64("retCode")
        var ret_msg = doc.get_str("retMsg")
        if ret_code != 0:
            raise Error(
                "error retCode=" + str(ret_code) + ", retMsg=" + ret_msg
            )

        var result = doc.get_object_mut("result")
        var _order_id = result.get_str("orderId")
        var _order_link_id = result.get_str("orderLinkId")

        return OrderResponse(order_id=_order_id, order_link_id=_order_link_id)

    fn cancel_order(
        self,
        category: String,
        symbol: String,
        order_id: String = "",
        order_link_id: String = "",
    ) raises -> OrderResponse:
        """
        Cancel order
        """
        var post_doc = JsonObject()
        post_doc.insert_str("category", category)
        post_doc.insert_str("symbol", symbol)
        if order_id != "":
            post_doc.insert_str("orderId", order_id)
        if order_link_id != "":
            post_doc.insert_str("orderLinkId", order_link_id)
        var body_str = post_doc.to_string()

        # print(body_str)

        var ret = self.do_post("/v5/order/cancel", body_str, True)
        # print(ret)
        if ret.status_code != 200:
            raise Error("error status=" + str(ret.status_code))

        # print(ret.body)

        # * {"retCode":10001,"retMsg":"params error: OrderId or orderLinkId is required","result":{},"retExtInfo":{},"time":1687611859585}
        # * {"retCode":110001,"retMsg":"Order does not exist","result":{},"retExtInfo":{},"time":1689203937336}
        # * {"retCode":0,"retMsg":"OK","result":{"orderId":"1c64212f-8b16-4d4b-90c1-7a4cb55f240a","orderLinkId":""},"retExtInfo":{},"time":1689204723386}
        var doc = JsonObject(ret.text)
        var ret_code = doc.get_i64("retCode")
        var ret_msg = doc.get_str("retMsg")
        if ret_code != 0:
            raise Error(
                "error retCode=" + str(ret_code) + ", retMsg=" + ret_msg
            )

        var result = doc.get_object_mut("result")
        var _order_id = result.get_str("orderId")
        var _order_link_id = result.get_str("orderLinkId")

        return OrderResponse(_order_id, _order_link_id)

    fn cancel_orders(
        self,
        category: String,
        symbol: String,
        base_coin: String = "",
        settle_coin: String = "",
    ) raises -> List[OrderResponse]:
        """
        Batch cancel orders
        """
        var post_doc = JsonObject()
        post_doc.insert_str("category", category)
        post_doc.insert_str("symbol", symbol)
        if base_coin != "":
            post_doc.insert_str("baseCoin", base_coin)
        if settle_coin != "":
            post_doc.insert_str("settleCoin", settle_coin)
        var body_str = post_doc.to_string()

        # print(body_str)

        var ret = self.do_post("/v5/order/cancel-all", body_str, True)
        # print(ret)
        if ret.status_code != 200:
            raise Error("error status=" + str(ret.status_code))

        # logd(ret.body)

        # * {"retCode":0,"retMsg":"OK","result":{"list":[]},"retExtInfo":{},"time":1687612231164}
        var res = List[OrderResponse]()

        var doc = JsonObject(ret.text)
        var ret_code = doc.get_i64("retCode")
        var ret_msg = doc.get_str("retMsg")
        if ret_code != 0:
            raise Error(
                "error retCode=" + str(ret_code) + ", retMsg=" + ret_msg
            )

        var result = doc.get_object_mut("result")
        var a_list = result.get_array_mut("list")

        var list_iter_a = a_list.iter()
        while True:
            var value = list_iter_a.next()
            if value.is_null():
                break
            var obj = value.as_object_ref()
            var order_id = obj.get_str("orderId")
            var order_link_id = obj.get_str("orderLinkId")
            res.append(
                OrderResponse(order_id=order_id, order_link_id=order_link_id)
            )

        return res

    fn fetch_balance(
        self, account_type: String, coin: String
    ) raises -> List[BalanceInfo]:
        """
        Fetch wallet balance.
        """
        var query_values = QueryParams()
        query_values["accountType"] = account_type
        query_values["coin"] = coin
        var query_str = query_values.to_string()
        var ret = self.do_get("/v5/account/wallet-balance", query_str, True)
        if ret.status_code != 200:
            raise Error("error status_code=" + str(ret.status_code))

        logi(ret.text)

        # {"retCode":0,"retMsg":"OK","result":{"list":[{"accountType":"CONTRACT","accountIMRate":"","accountMMRate":"","totalEquity":"","totalWalletBalance":"","totalMarginBalance":"","totalAvailableBalance":"","totalPerpUPL":"","totalInitialMargin":"","totalMaintenanceMargin":"","accountLTV":"","coin":[{"coin":"USDT","equity":"20.21","usdValue":"","walletBalance":"20.21","borrowAmount":"","availableToBorrow":"","availableToWithdraw":"20.21","accruedInterest":"","totalOrderIM":"0","totalPositionIM":"0","totalPositionMM":"","unrealisedPnl":"0","cumRealisedPnl":"0"}]}]},"retExtInfo":{},"time":1687608906096}
        var res = List[BalanceInfo]()

        var doc = JsonObject(ret.text)
        var ret_code = doc.get_i64("retCode")
        var ret_msg = doc.get_str("retMsg")
        if ret_code != 0:
            raise Error(
                "error retCode=" + str(ret_code) + ", retMsg=" + ret_msg
            )

        var coins = coin.split(",")

        var result_list = doc.get_object_mut("result").get_array_mut("list")
        var list_iter = result_list.iter()

        while True:
            var value = list_iter.next()
            if value.is_null():
                break
            var obj = value.as_object_ref()
            var account_type = obj.get_str("accountType")
            # logi("account_type=" + account_type)
            if account_type == "CONTRACT":
                var coin_list = obj.get_array_ref("coin")
                var coin_iter = coin_list.iter()
                while True:
                    var value1 = coin_iter.next()
                    if value1.is_null():
                        break
                    var coin_obj = value1.as_object_ref()
                    var coin_name = coin_obj.get_str("coin")
                    # logi("coin_name: " + coin_name + " coins: " + ",".join(coins))
                    if coin_name in coins:
                        # logi("coin_name: " + coin_name)
                        var equity = float(coin_obj.get_str("equity"))
                        var available_to_withdraw = float(
                            coin_obj.get_str("availableToWithdraw")
                        )
                        var wallet_balance = float(
                            coin_obj.get_str("walletBalance")
                        )
                        var total_order_im = float(
                            coin_obj.get_str("totalOrderIM")
                        )
                        var total_position_im = float(
                            coin_obj.get_str("totalPositionIM")
                        )
                        var unrealised_pnl = float(
                            coin_obj.get_str("unrealisedPnl")
                        )
                        var cum_realised_pnl = float(
                            coin_obj.get_str("cumRealisedPnl")
                        )
                        res.append(
                            BalanceInfo(
                                coin_name=coin_name,
                                equity=equity,
                                available_to_withdraw=available_to_withdraw,
                                wallet_balance=wallet_balance,
                                total_order_im=total_order_im,
                                total_position_im=total_position_im,
                                unrealised_pnl=unrealised_pnl,
                                cum_realised_pnl=cum_realised_pnl,
                            )
                        )

                _ = coin_list^
            elif account_type == "UNIFIED":
                var coin_list = obj.get_array_ref("coin")
                var coin_iter = coin_list.iter()
                while True:
                    var value1 = coin_iter.next()
                    if value1.is_null():
                        break
                    var coin_obj = value1.as_object_ref()
                    var coin_name = coin_obj.get_str("coin")
                    # logi("coin_name: " + coin_name + " coins: " + ",".join(coins))
                    if coin_name in coins:
                        """
                            {
                            "availableToBorrow": "",
                            "bonus": "0",
                            "accruedInterest": "0",
                            "availableToWithdraw": "24.99164765",
                            "totalOrderIM": "0",
                            "equity": "24.99164765",
                            "totalPositionMM": "0",
                            "usdValue": "24.97517815",
                            "unrealisedPnl": "0",
                            "collateralSwitch": true,
                            "spotHedgingQty": "0",
                            "borrowAmount": "0.000000000000000000",
                            "totalPositionIM": "0",
                            "walletBalance": "24.99164765",
                            "cumRealisedPnl": "0",
                            "locked": "0",
                            "marginCollateral": true,
                            "coin": "USDT"
                        }
                        """
                        # logi("coin_name: " + coin_name)
                        var equity = float(coin_obj.get_str("equity"))
                        var available_to_withdraw = float(
                            coin_obj.get_str("availableToWithdraw")
                        )
                        var wallet_balance = float(
                            coin_obj.get_str("walletBalance")
                        )
                        var total_order_im = float(
                            coin_obj.get_str("totalOrderIM")
                        )
                        var total_position_im = float(
                            coin_obj.get_str("totalPositionIM")
                        )
                        var unrealised_pnl = float(
                            coin_obj.get_str("unrealisedPnl")
                        )
                        var cum_realised_pnl = float(
                            coin_obj.get_str("cumRealisedPnl")
                        )
                        var borrow_amount = float(
                            coin_obj.get_str("borrowAmount")
                        )
                        res.append(
                            BalanceInfo(
                                coin_name=coin_name,
                                equity=equity,
                                available_to_withdraw=available_to_withdraw,
                                wallet_balance=wallet_balance,
                                total_order_im=total_order_im,
                                total_position_im=total_position_im,
                                unrealised_pnl=unrealised_pnl,
                                cum_realised_pnl=cum_realised_pnl,
                                borrow_amount=borrow_amount,
                            )
                        )

        return res

    fn fetch_orders(
        self,
        category: String,
        symbol: String,
        order_link_id: String = "",
        limit: Int = 0,
        cursor: String = "",
    ) raises -> List[OrderInfo]:
        """
        Fetch current orders
        https://bybit-exchange.github.io/docs/zh-TW/v5/order/open-order
        """
        var query_values = QueryParams()
        query_values["category"] = category
        query_values["symbol"] = symbol
        if order_link_id != "":
            query_values["orderLinkId"] = order_link_id
        if limit > 0:
            query_values["limit"] = str(limit)
        if cursor != "":
            query_values["cursor"] = cursor
        var query_str = query_values.to_string()
        logd("query_str: " + query_str)
        var ret = self.do_get("/v5/order/realtime", query_str, True)
        if ret.status_code != 200:
            raise Error(
                "error status_code="
                + str(ret.status_code)
                + " text="
                + str(ret.text)
            )

        # {"retCode":0,"retMsg":"OK","result":{"list":[],"nextPageCursor":"","category":"linear"},"retExtInfo":{},"time":1696392159183}
        # {"retCode":10002,"retMsg":"invalid request, please check your server timestamp or recv_window param. req_timestamp[1696396708819],server_timestamp[1696396707813],recv_window[15000]","result":{},"retExtInfo":{},"time":1696396707814}
        var res = List[OrderInfo]()

        var doc = JsonObject(ret.text)

        var ret_code = doc.get_i64("retCode")
        var ret_msg = doc.get_str("retMsg")
        if ret_code != 0:
            raise Error(
                "error retCode=" + str(ret_code) + ", retMsg=" + ret_msg
            )

        var result = doc.get_object_ref("result")
        var result_list = result.get_array_ref("list")

        var list_iter = result_list.iter()

        while True:
            var value = list_iter.next()
            if value.is_null():
                break
            var obj = value.as_object_ref()
            var position_idx = int(obj.get_i64("positionIdx"))
            var order_id = obj.get_str("orderId")
            var _symbol = obj.get_str("symbol")
            var side = obj.get_str("side")
            var order_type = obj.get_str("orderType")
            var price = float(obj.get_str("price"))
            var qty = float(obj.get_str("qty"))
            var cum_exec_qty = float(obj.get_str("cumExecQty"))
            var order_status = obj.get_str("orderStatus")
            var created_time = obj.get_str("createdTime")
            var updated_time = obj.get_str("updatedTime")
            var avg_price = float(obj.get_str("avgPrice"))
            var cum_exec_fee = float(obj.get_str("cumExecFee"))
            var time_in_force = obj.get_str("timeInForce")
            var reduce_only = obj.get_bool("reduceOnly")
            var order_link_id = obj.get_str("orderLinkId")

            res.append(
                OrderInfo(
                    position_idx=position_idx,
                    order_id=order_id,
                    symbol=_symbol,
                    side=side,
                    type_=order_type,
                    price=price,
                    qty=qty,
                    cum_exec_qty=cum_exec_qty,
                    status=order_status,
                    created_time=created_time,
                    updated_time=updated_time,
                    avg_price=avg_price,
                    cum_exec_fee=cum_exec_fee,
                    time_in_force=time_in_force,
                    reduce_only=reduce_only,
                    order_link_id=order_link_id,
                )
            )

        return res

    fn fetch_history_orders(
        self,
        category: String,
        symbol: String,
        order_id: String,
        order_link_id: String,
        order_filter: String = "",
        order_status: String = "",
        start_time_ms: Int = 0,
        end_time_ms: Int = 0,
        limit: Int = 0,
        cursor: String = "",
    ) raises -> List[OrderInfo]:
        """
        Fetch historical orders
        https://bybit-exchange.github.io/docs/zh-TW/v5/order/order-list
        """
        var query_values = QueryParams()
        query_values["category"] = category
        query_values["symbol"] = symbol
        if order_id != "":
            query_values["orderId"] = order_id
        if order_link_id != "":
            query_values["orderLinkId"] = order_link_id
        if order_filter != "":
            query_values["orderFilter"] = order_filter
        if order_status != "":
            query_values["orderStatus"] = order_status
        if start_time_ms > 0:
            query_values["startTimeMs"] = str(start_time_ms)
        if end_time_ms > 0:
            query_values["endTimeMs"] = str(end_time_ms)
        if limit > 0:
            query_values["limit"] = str(limit)
        if cursor != "":
            query_values["cursor"] = cursor
        var query_str = query_values.to_string()
        loge("query_str=" + query_str)
        var ret = self.do_get("/v5/order/history", query_str, True)
        if ret.status_code != 200:
            raise Error("error status_code=[" + str(ret.status_code) + "]")

        # print(ret.body)

        var res = List[OrderInfo]()

        var doc = JsonObject(ret.text)
        var ret_code = doc.get_i64("retCode")
        var ret_msg = doc.get_str("retMsg")
        if ret_code != 0:
            raise Error(
                "error retCode=" + str(ret_code) + ", retMsg=" + ret_msg
            )

        var result = doc.get_object_ref("result")
        var a_list = result.get_array_ref("list")

        var list_iter_a = a_list.iter()
        while True:
            var value = list_iter_a.next()
            if value.is_null():
                break
            var obj = value.as_object_ref()

            # position_idx: int   # positionIdx
            # order_id: StringLiteral       # orderId
            # symbol: StringLiteral
            # side: StringLiteral
            # type: StringLiteral
            # price: float
            # qty: float
            # cum_exec_qty: float # cumExecQty
            # status: StringLiteral         # orderStatus
            # created_time: StringLiteral   # createdTime
            # updated_time: StringLiteral   # updatedTime
            # avg_price: float    # avgPrice
            # cum_exec_fee: float # cumExecFee
            # time_in_force: StringLiteral  # timeInForce
            # reduce_only: bool   # reduceOnly
            # order_link_id: StringLiteral  # orderLinkId
            var position_idx = int(obj.get_i64("positionIdx"))
            var order_id = obj.get_str("orderId")
            var _symbol = obj.get_str("symbol")
            var side = obj.get_str("side")
            var order_type = obj.get_str("orderType")
            var price = float(obj.get_str("price"))
            var qty = float(obj.get_str("qty"))
            var cum_exec_qty = float(obj.get_str("cumExecQty"))
            var order_status = obj.get_str("orderStatus")
            var created_time = obj.get_str("createdTime")
            var updated_time = obj.get_str("updatedTime")
            var avg_price = float(obj.get_str("avgPrice"))
            var cum_exec_fee = float(obj.get_str("cumExecFee"))
            var time_in_force = obj.get_str("timeInForce")
            var reduce_only = obj.get_bool("reduceOnly")
            var order_link_id = obj.get_str("orderLinkId")

            res.append(
                OrderInfo(
                    position_idx=position_idx,
                    order_id=order_id,
                    symbol=_symbol,
                    side=side,
                    type_=order_type,
                    price=price,
                    qty=qty,
                    cum_exec_qty=cum_exec_qty,
                    status=order_status,
                    created_time=created_time,
                    updated_time=updated_time,
                    avg_price=avg_price,
                    cum_exec_fee=cum_exec_fee,
                    time_in_force=time_in_force,
                    reduce_only=reduce_only,
                    order_link_id=order_link_id,
                )
            )

        return res

    fn fetch_positions(
        self, category: String, symbol: String
    ) raises -> List[PositionInfo]:
        var query_values = QueryParams()
        query_values["category"] = category
        query_values["symbol"] = symbol
        # baseCoin, settleCoin, limit, cursor
        var query_str = query_values.to_string()
        var ret = self.do_get("/v5/position/list", query_str, True)
        if ret.status_code != 200:
            raise Error("error status=[" + str(ret.status_code) + "]")

        # {"retCode":10002,"retMsg":"invalid request, please check your server timestamp or recv_window param. req_timestamp[1696255257619],server_timestamp[1696255255967],recv_window[15000]","result":{},"retExtInfo":{},"time":1696255255967}

        # logi(ret.body)

        var res = List[PositionInfo]()
        var doc = JsonObject(ret.text)
        var ret_code = doc.get_i64("retCode")
        var ret_msg = doc.get_str("retMsg")
        if ret_code != 0:
            raise Error(
                "error retCode=" + str(ret_code) + ", retMsg=" + ret_msg
            )

        var result = doc.get_object_ref("result")
        var a_list = result.get_array_ref("list")

        var list_iter_a = a_list.iter()
        while True:
            var value = list_iter_a.next()
            if value.is_null():
                break
            var obj = value.as_object_ref()

            var _symbol = obj.get_str("symbol")
            if _symbol != symbol:
                continue

            # {
            #     "positionIdx": 0,
            #     "riskId": 1,
            #     "riskLimitValue": "2000000",
            #     "symbol": "BTCUSDT",
            #     "side": "None",
            #     "size": "0.000",
            #     "avgPrice": "0",
            #     "positionValue": "0",
            #     "tradeMode": 0,
            #     "positionStatus": "Normal",
            #     "autoAddMargin": 0,
            #     "adlRankIndicator": 0,
            #     "leverage": "1",
            #     "positionBalance": "0",
            #     "markPrice": "26515.73",
            #     "liqPrice": "",
            #     "bustPrice": "0.00",
            #     "positionMM": "0",
            #     "positionIM": "0",
            #     "tpslMode": "Full",
            #     "takeProfit": "0.00",
            #     "stopLoss": "0.00",
            #     "trailingStop": "0.00",
            #     "unrealisedPnl": "0",
            #     "cumRealisedPnl": "-19.59637027",
            #     "seq": 8172241025,
            #     "createdTime": "1682125794703",
            #     "updatedTime": "1694995200083"
            # }

            var _position_idx = int(obj.get_i64("positionIdx"))
            # _risk_id = i["riskId"].int()
            var _side = obj.get_str("side")
            var _size = obj.get_str("size")
            var _avg_price = obj.get_str("avgPrice")
            var _position_value = obj.get_str("positionValue")
            var _leverage = obj.get_str("leverage")
            var _mark_price = obj.get_str("markPrice")
            # _liq_price = i["liqPrice"].str()
            # _bust_price = i["bustPrice"].str()
            var _position_mm = obj.get_str("positionMM")
            var _position_im = obj.get_str("positionIM")
            var _take_profit = obj.get_str("takeProfit")
            var _stop_loss = obj.get_str("stopLoss")
            var _unrealised_pnl = obj.get_str("unrealisedPnl")
            var _cum_realised_pnl = obj.get_str("cumRealisedPnl")
            # _seq = i["seq"].int()
            var _created_time = obj.get_str("createdTime")
            var _updated_time = obj.get_str("updatedTime")
            var pos = PositionInfo(
                position_idx=_position_idx,
                symbol=_symbol,
                side=_side,
                size=_size,
                avg_price=_avg_price,
                position_value=_position_value,
                leverage=float(_leverage),
                mark_price=_mark_price,
                position_mm=_position_mm,
                position_im=_position_im,
                take_profit=_take_profit,
                stop_loss=_stop_loss,
                unrealised_pnl=_unrealised_pnl,
                cum_realised_pnl=_cum_realised_pnl,
                created_time=_created_time,
                updated_time=_updated_time,
            )
            res.append(pos)

        return res

    fn do_sign(
        self, inout headers: Headers, borrowed data: String, sign: Bool
    ) raises -> None:
        if not sign:
            return
        var time_ms_str = str(int(now_ns() / 1e6))
        # logi("time_ms_str=" + time_ms_str)
        var recv_window_str = "15000"
        # logd("do_sign: " + data)
        var payload = data
        # logd("do_sign: " + data)
        var param_str = time_ms_str + self.access_key + recv_window_str + payload
        var sign_str = hmac_sha256_hex(param_str, self.secret_key)
        headers["X-BAPI-API-KEY"] = self.access_key
        headers["X-BAPI-TIMESTAMP"] = time_ms_str
        headers["X-BAPI-SIGN"] = sign_str
        headers["X-BAPI-RECV-WINDOW"] = recv_window_str

    fn do_get(
        self, path: StringLiteral, param: String, sign: Bool
    ) raises -> HttpResponse:
        var headers = Headers()
        # headers["Connection"] = "Keep-Alive"
        var param_ = param
        self.do_sign(headers, param, sign)

        var request_path: String
        if param != "":
            request_path = str(path) + "?" + param_
        else:
            request_path = path
        # logd("request_path: " + request_path)
        # logd("param: " + param_)
        var res = self.client.get(request_path, headers=headers)
        # logd("res.status_code=" + str(res.status_code) + " text=" + res.text)
        return res

    fn do_post(
        self, path: StringLiteral, body: String, sign: Bool
    ) raises -> HttpResponse:
        var headers = Headers()
        # headers["Connection"] = "Keep-Alive"
        headers["Content-Type"] = "application/json"
        self.do_sign(headers, body, sign)
        var res = self.client.post(path, payload=body, headers=headers)
        # logd("res.status=" + str(res.status_code) + " text=" + res.text)
        return res


# {"retCode":10010,"retMsg":"Unmatched IP, please check your API key's bound IP addresses.","result":{},"retExtInfo":{},"time":1701783283807}
# {"retCode":10004,"retMsg":"error sign! origin_string[1701783394711de21RcqOIH8Gfxvxvv15000]","result":{},"retExtInfo":{},"time":1701783394740}
