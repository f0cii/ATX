import sys
import time


from atxsys import *
from gateio_ws import Configuration, Connection, WebSocketResponse, BaseChannel

# from gateio_ws.spot import SpotOrderBookUpdateChannel
from sonic import *


# class SimpleRingBuffer(object):
#     """Simple ring buffer to cache order book updates

#     But can be used in other general scenario too
#     """

#     def __init__(self, size: int):
#         self.max = size
#         self.data = []
#         self.cur = 0

#     class __Full:
#         # to avoid warning hints from IDE
#         max: int
#         data: typing.List
#         cur: int

#         def append(self, x):
#             self.data[self.cur] = x
#             self.cur = (self.cur + 1) % self.max

#         def __iter__(self):
#             for i in itertools.chain(range(self.cur, self.max), range(self.cur)):
#                 yield self.data[i]

#         def get(self, idx):
#             return self.data[(self.cur + idx) % self.max]

#         def __getitem__(self, item):
#             if isinstance(item, int):
#                 return self.get(item)
#             return (self.data[self.cur:] + self.data[:self.cur]).__getitem__(item)

#         def __len__(self):
#             return self.max

#     def __iter__(self):
#         for i in self.data:
#             yield i

#     def append(self, x):
#         self.data.append(x)
#         if len(self.data) == self.max:
#             self.cur = 0
#             # Permanently change self's class from non-full to full
#             self.__class__ = self.__Full

#     def get(self, idx):
#         return self.data[idx]

#     def __getitem__(self, item):
#         return self.data.__getitem__(item)

#     def __len__(self):
#         return len(self.data)


# class OrderBookEntry(object):

#     def __init__(self, price, amount):
#         self.price: Decimal = Decimal(price)
#         self.amount: str = amount

#     def __eq__(self, other):
#         return self.price == other.price

#     def __str__(self):
#         return '(%s, %s)' % (self.price, self.amount)


# class OrderBook(object):

#     def __init__(self, cp: str, last_id: id, asks: SortedList, bids: SortedList):
#         self.cp = cp
#         self.id = last_id
#         self.asks = asks
#         self.bids = bids

#     @classmethod
#     def update_entry(cls, book: SortedList, entry: OrderBookEntry):
#         if Decimal(entry.amount) == Decimal('0'):
#             # remove price if amount is 0
#             try:
#                 book.remove(entry)
#             except ValueError:
#                 pass
#         else:
#             try:
#                 idx = book.index(entry)
#             except ValueError:
#                 # price not found, insert it
#                 book.add(entry)
#             else:
#                 # price found, update amount
#                 book[idx].amount = entry.amount

#     def __str__(self):
#         return '\n  id: %d\n  asks:\n%s\n  bids:\n%s' % (self.id,
#                                                          '\n'.join([' ' * 4 + str(a) for a in self.asks]),
#                                                          '\n'.join([' ' * 4 + str(b) for b in self.bids]))

#     def update(self, ws_update):
#         if ws_update['u'] < self.id + 1:
#             # ignore older message
#             return
#         if ws_update['U'] > self.id + 1:
#             raise ValueError("base order book ID %d falls behind update between %d-%d" %
#                              (self.id, ws_update['U'], ws_update['u']))
#         # start from the first message which satisfies U <= ob.id+1 <= u
#         logger.debug("current id %d, update from %s", self.id, ws_update)
#         for ask in ws_update['a']:
#             entry = OrderBookEntry(*ask)
#             self.update_entry(self.asks, entry)
#         for bid in ws_update['b']:
#             entry = OrderBookEntry(*bid)
#             self.update_entry(self.bids, entry)
#         # update local order book ID
#         # check order book overlapping
#         if len(self.asks) > 0 and len(self.bids) > 0:
#             if self.asks[0].price <= self.bids[0].price:
#                 raise ValueError("price overlapping, min ask price %s not greater than max bid price %s" % (
#                     self.asks[0].price, self.bids[0].price))
#         self.id = ws_update['u']


# class LocalOrderBook(object):

#     def __init__(self, currency_pair: str):
#         self.cp = currency_pair
#         self.q = asyncio.Queue(maxsize=500)
#         self.buf = SimpleRingBuffer(size=500)
#         self.ob = OrderBook(self.cp, 0, SortedList(), SortedList())

#     @property
#     def id(self):
#         return self.ob.id

#     @property
#     def asks(self):
#         return self.ob.asks

#     @property
#     def bids(self):
#         return self.ob.bids

#     async def construct_base_order_book(self) -> OrderBook:
#         while True:
#             async with aiohttp.ClientSession() as session:
#                 # aiohttp does not allow boolean parameter variable
#                 async with session.get('https://api.gateio.ws/api/v4/spot/order_book',
#                                        params={'currency_pair': self.cp, 'limit': 100, 'with_id': 'true'}) as response:
#                     if response.status != 200:
#                         logger.warning("failed to retrieve base order book: ", await response.text())
#                         await asyncio.sleep(1)
#                         continue
#                     result = await response.json()
#                     assert isinstance(result, dict)
#                     assert result.get('id')
#                     logger.debug("retrieved new base order book with id %d", result.get('id'))
#                     ob = OrderBook(self.cp, result.get('id'),
#                                    SortedList([OrderBookEntry(*x) for x in result.get('asks')], key=lambda x: x.price),
#                                    # sort bid from high to low
#                                    SortedList([OrderBookEntry(*x) for x in result.get('bids')], key=lambda x: -x.price))
#             # use cached result to recover our local order book fast
#             for b in self.buf:
#                 try:
#                     ob.update(b)
#                 except ValueError as e:
#                     logger.warning("failed to update: %s", e)
#                     await asyncio.sleep(0.5)
#                     break
#             else:
#                 return ob

#     async def run(self):
#         while True:
#             self.ob = await self.construct_base_order_book()
#             while True:
#                 result = await self.q.get()
#                 try:
#                     self.ob.update(result)
#                     # print(result)
#                 except ValueError as e:
#                     logger.error("failed to update: %s", e)
#                     # reconstruct order book
#                     break

#     def _cache_update(self, ws_update):
#         if len(self.buf) > 0:
#             last_id = self.buf[-1]['u']
#             if ws_update['u'] < last_id:
#                 # ignore older message
#                 return
#             if ws_update['U'] != last_id + 1:
#                 # update message not consecutive, reconstruct cache
#                 self.buf = SimpleRingBuffer(size=100)
#         self.buf.append(ws_update)

#     async def ws_callback(self, conn: Connection, response: WebSocketResponse):
#         if response.error:
#             # stop the client if error happened
#             conn.close()
#             raise response.error
#         # ignore subscribe success response
#         if 's' not in response.result or response.result.get('s') != self.cp:
#             return
#         result = response.result
#         logger.debug("received update: %s", result)
#         assert isinstance(result, dict)
#         self._cache_update(result)
#         await self.q.put(result)


fn test_ws_orderbook() raises:
    var conn = Connection(Configuration())
    var demo_cp = "BTC_USDT"
    # var order_book = LocalOrderBook(demo_cp)
    var channel = BaseChannel(
        "spot.order_book_update", conn
    )  # , order_book.ws_callback)

    var ioc = seq_asio_ioc()
    seq_asio_run_ex(ioc, -1, False)

    conn.connect()

    # 要等待连接完毕
    time.sleep(3)

    var p = JsonValue()
    # var a = p.array()
    var pv = JsonValueArrayView(p)
    pv.push_str(demo_cp)
    pv.push_str("100ms")
    print("p", str(p))
    # channel.subscribe([demo_cp, "100ms"])
    channel.subscribe(p)

    time.sleep(50000)
    _ = conn^


fn test_ws_order() raises:
    # var app = "spot"
    var app = "futures"
    var settle = "usdt"
    var test_net = True
    var api_key = "10d23703c09150b1bf4c5bb7f0f1dd2e"
    var api_secret = "996c14c32700f3ce63d0f5530793766a7b8bda8cdfaf5d71071915235f3d3f50"
    var conn = Connection(Configuration(app=app, settle=settle, test_net=test_net, api_key=api_key, api_secret=api_secret))
    var demo_cp = "BTC_USDT"
    # var order_book = LocalOrderBook(demo_cp)
    var channel = BaseChannel(
        "futures.order_place", conn
    )  # , order_book.ws_callback)

    # 登录成功返回
    # {"header":{"response_time":"1729479533423","status":"200","channel":"futures.login","event":"api","client_id":"223.112.219.22-0xc24eeaf900"},"data":{"result":{"uid":"16792411","api_key":"10d23703c09150b1bf4c5bb7f0f1dd2e"}},"request_id":"req_id"}

    var ioc = seq_asio_ioc()
    seq_asio_run_ex(ioc, -1, False)

    conn.connect()

    # 要等待连接完毕
    time.sleep(3)

    # var p = JSON(is_array=True)
    # # var a = p.array()
    # p.array().append(demo_cp)
    # p.array().append("100ms")
    # print("p", str(p))
    # # channel.subscribe([demo_cp, "100ms"])
    # channel.subscribe(p)

    channel.login("header", "req_id")

    time.sleep(3)

    # 下单
    # var order_place_param = Dict[String, object]{
    #     "text": "t-sssd",
    #     "currency_pair": "BCH_USDT",
    #     "type": "limit",
    #     "account": "spot",
    #     "side": "buy",
    #     "iceberg": "0",
    #     "price": "20",
    #     "amount": "0.05",
    #     "time_in_force": "gtc",
    #     "auto_borrow": False,
    # }
    var order_place_param = JsonValue.from_str('{}')
    var param = JsonValueObjectView(order_place_param)

    """
    字段	类型	必选	描述
    contract	string	是	合约
    size	int64	是	订单大小。指定正数进行出价，指定负数进行询问
    iceberg	int64	是	冰山订单的显示尺寸。0 表示非冰山。请注意，您需要支付隐藏尺寸的接受者费用
    price	string	否	订单价格。0 表示市价订单，tif设置为ioc
    close	bool	否	设置为true平仓，size设置为 0
    reduce_only	bool	否	设置为true仅减少订单
    tif	string	否	有效时间
    text	string	否	用户定义的信息。如果不为空，则必须遵循以下规则：
    auto_size	string	否	将侧面设置为关闭双模式位置。close_long闭合长边；而close_short短的。注意size还需要设置为 0
    stp_act	string	否	自我交易预防行动。用户可以通过该字段设置自助交易防范策略
    """
    # order_place_param.object()[""] = 1
    param.insert_str("text", "t-sssd")
    param.insert_str("contract", "XRP_USDT")
    param.insert_i64("iceberg", 0)
    param.insert_str("price", "0.5")
    param.insert_i64("size", 1)
    param.insert_bool("close", False)
    param.insert_bool("reduce_only", False)
    # param.insert_str("time_in_force", "gtc")
    # param.insert_bool("auto_borrow", False)
    channel.api_request(order_place_param, "header", "001")

    # {"header":{"response_time":"1729492409735","status":"200","channel":"futures.order_place","event":"api","client_id":"223.112.219.22-0xc0f0cade00","conn_id":"42d8a6e51b66cf33","trace_id":"2cd7b9a2344374a90d0e1e9159f6680e"},"data":{"result":{"req_id":"001","api_key":"10d23703c09150b1bf4c5bb7f0f1dd2e","timestamp":"1729492408","signature":"9ed7c5dc0b37c64f962a3cb0c2e360f4828ceeff18379cb80837ac26d7935f753fae4efdfb2bf9011a3a4080d64f64cf8b9b94a6a5c5917eeef9e20a98950069","trace_id":"2cd7b9a2344374a90d0e1e9159f6680e","text":"","req_header":{"X-Gate-Channel-Id":"header","trace_id":"2cd7b9a2344374a90d0e1e9159f6680e"},"req_param":{"type":"limit","account":"futures","side":"buy","amount":"0.005","time_in_force":"gtc","auto_borrow":false,"text":"t-sssd","currency_pair":"BCH_USDT","iceberg":"0","price":"10"}}},"request_id":"001","ack":true}
    # {"header":{"response_time":"1729492409735","status":"400","channel":"futures.order_place","event":"api","client_id":"223.112.219.22-0xc0f0cade00"},"data":{"errs":{"label":"INVALID_REQUEST","message":"Mismatch type int64 with value string \"at index 161: mismatched type with value\\n\\n\\tUSDT\\\",\\\"iceberg\\\":\\\"0\\\",\\\"price\\\":\\\"10\\\"\\n\\t................^...............\\n\""}},"request_id":"001"}


# {
#     "header": {
#         "response_time": "1729492409735",
#         "status": "400",
#         "channel": "futures.order_place",
#         "event": "api",
#         "client_id": "223.112.219.22-0xc0f0cade00"
#     },
#     "data": {
#         "errs": {
#             "label": "INVALID_REQUEST",
#             "message": "Mismatch type int64 with value string \"at index 161: mismatched type with value\\n\\n\\tUSDT\\\",\\\"iceberg\\\":\\\"0\\\",\\\"price\\\":\\\"10\\\"\\n\\t................^...............\\n\""
#         }
#     },
#     "request_id": "001"
# }

    # {"header":{"response_time":"1729496213064","status":"200","channel":"futures.order_place","event":"api","client_id":"223.112.219.22-0xc17387e8c0"},"data":{"result":{"text":"t-sssd","price":"0.5","biz_info":"ch:header","tif":"gtc","amend_text":"-","status":"open","contract":"XRP_USDT","stp_act":"-","fill_price":"0","id":4001255877,"create_time":1729496213.064,"size":1,"update_time":1729496213.064,"left":1,"user":16792411}},"request_id":"001"}
    # {"header":{"response_time":"1729496213064","status":"200","channel":"futures.order_place","event":"api","client_id":"223.112.219.22-0xc17387e8c0"},"data":{"result":{"text":"t-sssd","price":"0.5","biz_info":"ch:header","tif":"gtc","amend_text":"-","status":"open","contract":"XRP_USDT","stp_act":"-","fill_price":"0","id":4001255877,"create_time":1729496213.064,"size":1,"update_time":1729496213.064,"left":1,"user":16792411}},"request_id":"001"}

    time.sleep(50000)
    _ = conn^


fn main() raises:
    _ = seq_ct_init()
    _ = seq_photon_init_default()
    # seq_init_photon_work_pool(1)
    var log_level = "DBG"
    var log_file = ""
    init_log(log_level, log_file)

    # test_ws_orderbook()
    test_ws_order()
