import time
import hashlib
from collections import Optional
from python import Python, PythonObject
from base.time_util import now_ms, now_ns
from atxsys import *
from atxsys.httpclient import (
    HttpClient,
    Headers,
    QueryParams,
    HttpResponse,
    DEFAULT_BUFF_SIZE,
)

# https://github.com/gateiobot/asyncGateIoAPI/blob/master/restapi/BaseClient.py

alias METHOD_GET = "GET"
alias METHOD_POST = "POST"
alias METHOD_PUT = "PUT"
alias METHOD_DELETE = "DELETE"
alias METHOD_PATCH = "PATCH"


struct GateIOFuturesClient:
    var api_key: String
    var api_secret: String
    var base_url: String
    var path_prefix: String
    var client: HttpClient

    fn __init__(
        inout self, api_key: String, api_secret: String, base_url: String
    ):
        # domain = "https://api.gateio.ws/api/v4"
        # domain = "https://fx-api-testnet.gateio.ws/api/v4"
        self.api_key = api_key
        self.api_secret = api_secret
        self.base_url = base_url
        self.path_prefix = "/api/v4"
        logi("self.baes_url=" + self.base_url)
        self.client = HttpClient(self.base_url)
        self.client.set_verbose(True)

    fn _request(
        self,
        method: String,
        path: String,
        param_string: String = "",
        payload: String = "",
        is_auth_required: Bool = False,
    ) raises -> String:
        var response = HttpResponse(0, "")
        try:
            var headers = Headers()
            var path_ = path + "?" + param_string if len(
                param_string
            ) > 0 else path
            logd("path_=" + path_)
            if is_auth_required:
                self._set_auth_headers(
                    headers, method, path, param_string, payload
                )
            if method == METHOD_GET:
                response = self.client.get(
                    path_, headers=headers
                )  # params=params,
            elif method == METHOD_POST:
                response = self.client.post(
                    path_, payload=payload, headers=headers  # params=params,
                )
            elif method == METHOD_PUT:
                response = self.client.put(
                    path_, payload=payload, headers=headers  # params=params,
                )
            elif method == METHOD_DELETE:
                response = self.client.delete(
                    path_, headers=headers
                )  # params=params,

            elif (
                method == METHOD_PATCH
            ):  # Simulate PATCH request using request method
                # response = self.client.request(
                #     "PATCH", url, data=data, headers=headers # params=params,
                # )
                # response = self.client.do_request(
                #     url, "PATCH", headers, "", DEFAULT_BUFF_SIZE
                # )
                pass
            else:
                raise Error("http method error!")
        except e:
            # logger.error(
            #     "method:",
            #     method,
            #     "url:",
            #     url,
            #     "headers:",
            #     headers,
            #     "params:",
            #     params,
            #     "body:",
            #     data,
            #     "data:",
            #     data,
            #     "Error:",
            #     e,
            # )
            raise Error(str(e))

        var code = response.status_code
        text = response.text

        if code not in (200, 201, 202, 203, 204, 205, 206):
            # logger.error(
            #     "method:",
            #     method,
            #     "url:",
            #     url,
            #     "headers:",
            #     headers,
            #     "params:",
            #     params,
            #     "body:",
            #     data,
            #     "data:",
            #     data,
            #     "code:",
            #     code,
            #     "result:",
            #     text,
            # )
            raise Error(text)
        # try:
        #     result = response.json()
        # except:
        #     result = response.text

        return text

    fn _set_auth_headers(
        self,
        inout headers: Headers,
        method: String,
        url: String,
        param_string: String,
        data: String,
    ) raises:
        # var sign, ts = self._sign_payload(method, url, params, data)
        var ts = int(now_ms() / 1000)
        var sign = self._sign_payload(method, url, param_string, data, ts)
        headers["KEY"] = self.api_key
        headers["SIGN"] = sign
        headers["Timestamp"] = str(ts)
        headers["Accept"] = "application/json"
        headers["Content-Type"] = "application/json"
        headers["X-Gate-Channel-Id"] = "daniugege"

    fn _sign_payload(
        self,
        method: String,
        path: String,
        param_string: String,
        data: String,
        ts: Int,
    ) raises -> String:
        var query_string = param_string

        # https://github.com/OnlyF0uR/OpenSSL-Mojo/blob/main/main.mojo

        var body_hash: String
        if len(data) > 0:
            body_hash = sha512_hex(data)
        else:
            # 这里直接设置固定值，加快速度
            # body_hash = sha512_hex("")
            body_hash = "cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e"

        # s = f"{method}\n{path}\n{query_string}\n{body_hash}\n{ts}"
        # var s = method + "\n" + path + "\n" + query_string + "\n" + body_hash + "\n" + str(
        #     ts
        # )
        var s = String.write(
            method, "\n", path, "\n", query_string, "\n", body_hash, "\n", ts
        )
        # logi(s)
        return self._sign(s)

    @always_inline
    fn _sign(self, payload: String) raises -> String:
        return hmac_sha512_hex(payload, self.api_secret)

    fn get_contracts(
        self, settle: String, limit: Int = -1, offset: Int = -1
    ) raises -> String:
        var params = QueryParams()
        var url = self.path_prefix + "/futures/" + settle + "/contracts"
        if limit > -1:
            params["limit"] = str(limit)
        if offset > -1:
            params["offset"] = str(offset)
        var param_string = params.to_string()
        var text = self._request(
            METHOD_GET, url, param_string=param_string, is_auth_required=False
        )
        # [{"funding_rate_indicative":"0.0001","mark_price_round":"0.0001","funding_offset":0,"in_delisting":true,"risk_limit_base":"500000","interest_rate":"0.0003","index_price":"0.2704","order_price_round":"0.0001","order_size_min":1,"ref_rebate_rate":"0.2","name":"MELON_USDT","ref_discount_rate":"0","order_price_deviate":"0.5","maintenance_rate":"0.025","mark_type":"index","funding_interval":28800,"type":"direct","risk_limit_step":"500000","enable_bonus":false,"enable_credit":true,"leverage_min":"1","funding_rate":"0.0001","last_price":"0.4784","mark_price":"0.2733","order_size_max":1000000,"funding_next_apply":1728748800,"short_users":2,"config_change_time":1718107904,"create_time":0,"trade_size":3339625,"position_size":9603,"long_users":3,"quanto_multiplier":"1","funding_impact_value":"5000","leverage_max":"20","cross_leverage_default":"10","risk_limit_max":"5000000","maker_fee_rate":"-0.0001","taker_fee_rate":"0.00075","orders_limit":50,"trade_id":389311,"orderbook_id":3634063,"funding_cap_ratio":"0.75","voucher_leverage":"0"}]
        return text

    fn get_contract(self, settle: String, contract: String) raises -> String:
        var url = self.path_prefix + "/futures/" + settle + "/contracts/" + contract
        var text = self._request(METHOD_GET, url, is_auth_required=False)
        # {"funding_rate_indicative":"0.0001","mark_price_round":"0.01","funding_offset":0,"in_delisting":false,"risk_limit_base":"1000000","interest_rate":"0.0003","index_price":"62633.94","order_price_round":"0.1","order_size_min":1,"ref_rebate_rate":"0.2","name":"BTC_USDT","ref_discount_rate":"0","order_price_deviate":"0.2","maintenance_rate":"0.004","mark_type":"index","funding_interval":28800,"type":"direct","risk_limit_step":"1000000","enable_bonus":true,"enable_credit":true,"leverage_min":"1","funding_rate":"0.0001","last_price":"62616.2","mark_price":"62637.35","order_size_max":10000000,"funding_next_apply":1728835200,"short_users":1564,"config_change_time":1728705511,"create_time":0,"trade_size":228977128276,"position_size":171497179,"long_users":2366,"quanto_multiplier":"0.0001","funding_impact_value":"3000000","leverage_max":"125","cross_leverage_default":"10","risk_limit_max":"100000000","maker_fee_rate":"-0.0001","taker_fee_rate":"0.00075","100orders_limit":200,"trade_id":50264505,"orderbook_id":539734479,"funding_cap_ratio":"0.75","voucher_leverage":"0"}
        return text

    fn get_order_book(
        self,
        settle: String,
        contract: String,
        interval: String = "0",
        limit: Int = 10,
        with_id: Bool = False,
    ) raises -> String:
        var params = QueryParams()
        params["contract"] = contract
        params["interval"] = interval
        params["limit"] = str(limit)
        params["with_id"] = str(with_id)
        var url = self.path_prefix + "/futures/" + settle + "/order_book"
        var param_string = params.to_string()
        var res = self._request(
            METHOD_GET, url, param_string=param_string, is_auth_required=False
        )
        return res

    fn place_order(
        self,
        settle: String,
        contract: String,
        size: Int,
        iceberg: Int = -1,
        price: String = "",
        close: Bool = False,
        reduce_only: Bool = False,
        tif: String = "",
        text: String = "",
        auto_size: String = "",
    ) raises -> String:
        """
        合约交易下单
        下单时指定的是合约张数 size ，而非币的数量，每一张合约对应的币的数量是合约详情接口里返回的 quanto_multiplier
        0 成交的订单在撤单 10 分钟之后无法再获取到，会提到订单不存在
        设置 reduce_only 为 true 可以防止在减仓的时候穿仓
        单仓模式下，如果需要平仓，需要设置 size 为 0 ，close 为 true
        双仓模式下，平仓需要使用 auto_size 来设置平仓方向，并同时设置 reduce_only 为 true，size 为 0
        设置 stp_act 决定使用限制用户自成交的策略，详细用法参考body参数stp_act.

        tif: Time in force 策略，市价单当前只支持 ioc 模式

        - gtc: GoodTillCancelled
        - ioc: ImmediateOrCancelled，立即成交或者取消，只吃单不挂单
        - poc: PendingOrCancelled，被动委托，只挂单不吃单
        - fok: FillOrKill, 完全成交，或者完全取消
        stp_act: co,cn,cb,-

        https://www.gate.io/docs/developers/apiv4/zh_CN/#%E5%90%88%E7%BA%A6%E4%BA%A4%E6%98%93%E4%B8%8B%E5%8D%95
        """

        # {"contract":symbol,"size":size,"price": price,"tif": tif,"close": close,"auto_size":auto_size,"reduce_only":reduce_only}

        var path = self.path_prefix + "/futures/" + settle + "/orders"
        var data = SonicDocument()
        data.add_string("contract", contract)
        data.add_int("size", size)
        if iceberg >= 0:
            data.add_int("iceberg", iceberg)
        if len(price) > 0:
            data.add_string("price", price)
        if close:
            data.add_bool("close", close)
        if reduce_only:
            data.add_bool("reduce_only", reduce_only)
        if len(tif):
            data.add_string("tif", tif)
        if len(text) > 0:
            data.add_string("text", text)
        if len(auto_size) > 0:
            data.add_string("auto_size", auto_size)
        var data_string = data.to_string()
        var res = self._request(
            METHOD_POST, path, payload=data_string, is_auth_required=True
        )
        # {"label":"INVALID_PARAM_VALUE","message":"Invalid request parameter `size` value: 0.001"}
        # {"label":"PRICE_TOO_DEVIATED","message":"order price 50000 while mark price 62630.93 and deviation-rate limit 0.2"}
        # {"refu":0,"tkfr":"0.0005","mkfr":"0.0002","contract":"BTC_USDT","id":3988353982,"price":"60000","tif":"gtc","iceberg":0,"text":"api","user":16792411,"is_reduce_only":false,"is_close":false,"is_liq":false,"fill_price":"0","create_time":1728819681.844,"update_time":1728819681.844,"status":"open","left":1,"refr":"0","size":1,"biz_info":"ch:daniugege","amend_text":"-","stp_act":"-","stp_id":0,"update_id":1,"pnl":"0","pnl_margin":"0"}
        return res

    fn get_futures_orders(
        self,
        settle: String,
        status: String,
        contract: Optional[String] = None,
        limit: Optional[Int] = None,
        offset: Optional[Int] = None,
        last_id: Optional[String] = None,
    ) raises -> String:
        """
        status: open/finished.
        """
        var url = self.path_prefix + "/futures/" + settle + "/orders"
        var params = QueryParams()
        params["status"] = status
        if contract is not None:
            params["contract"] = contract.value()
        if limit is not None:
            params["limit"] = str(limit.value())
        if offset is not None:
            params["offset"] = str(offset.value())
        if last_id is not None:
            params["last_id"] = str(last_id.value())
        var param_string = params.to_string()
        var res = self._request(
            METHOD_GET, url, param_string=param_string, is_auth_required=True
        )
        # {"label":"INVALID_SIGNATURE","message":"Signature mismatch"}
        return res

    # 批量取消状态为 open 的订单
    # fn cancel_open_orders(
    #     self, settle: str, contract: str, side: str = None
    # ):
    #     url = f"/futures/{settle}/orders"
    #     params = {"contract": contract}
    #     if side is not None:
    #         params["side"] = side
    #     success, error = await self._request(
    #         "DELETE", url, params=params, is_auth_required=True
    #     )
    #     return success, error

    # # 查询合约订单列表(时间区间)
    # fn get_orders_in_time_range(
    #     self,
    #     settle: String,
    #     contract: String = None,
    #     from_timestamp: Int = None,
    #     to_timestamp: Int = None,
    #     limit: Int = None,
    #     offset: Int = None,
    # ):
    #     url = f"/futures/{settle}/orders_timerange"
    #     params = {}
    #     if contract is not None:
    #         params["contract"] = contract
    #     if from_timestamp is not None:
    #         params["from"] = from_timestamp
    #     if to_timestamp is not None:
    #         params["to"] = to_timestamp
    #     if limit is not None:
    #         params["limit"] = limit
    #     if offset is not None:
    #         params["offset"] = offset

    #     success, error = await self._request(
    #         "GET", url, params=params, is_auth_required=True
    #     )
    #     return success, error

    # # 合约交易批量下单
    # fn place_batch_orders(
    #     self, settle: String, futuresorders: List[Dict[str, Any]]
    # ) raises -> String:
    #     var url = self.path_prefix + "/futures/" + settle + "/batch_orders"
    #     data = json.dumps(futuresorders)
    #     var res = await self._request(
    #         "POST", url, data=data, is_auth_required=True
    #     )
    #     return res

    # 查询单个订单详情
    fn get_order(self, settle: String, order_id: String) raises -> String:
        var url = self.path_prefix + "/futures/" + settle + "/orders/" + order_id
        var res = self._request("GET", url, is_auth_required=True)
        return res

    # 撤销单个订单
    fn cancel_order(self, settle: String, order_id: String) raises -> String:
        var url = self.path_prefix + "/futures/" + settle + "/orders/" + order_id
        var res = self._request(METHOD_DELETE, url, is_auth_required=True)
        return res

    fn modify_order(
        self,
        settle: String,
        order_id: String,
        size: Optional[Int] = None,
        price: Optional[String] = None,
        amend_text: Optional[String] = None,
    ) raises -> String:
        var url = self.path_prefix + "/futures/" + settle + "/orders/" + order_id
        var body = SonicDocument()
        if size is not None:
            body.add_int("size", size.value())
        if price is not None:
            body.add_string("price", price.value())
        if amend_text is not None:
            body.add_string("amend_text", amend_text.value())
        var payload = body.to_string()
        var res = self._request(
            METHOD_PUT, url, payload=payload, is_auth_required=True
        )
        return res
