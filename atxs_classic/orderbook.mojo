from sys.ffi import DLHandle
from memory import UnsafePointer
from .internal.orderbook import *


@value
@register_passable
struct OrderBookLevel(CollectionElement):
    var price: Fixed
    var qty: Fixed


@value
struct OrderBookLite:
    var symbol: String
    var asks: List[OrderBookLevel]
    var bids: List[OrderBookLevel]

    fn __init__(out self, symbol: String = ""):
        self.symbol = symbol
        self.asks = List[OrderBookLevel]()
        self.bids = List[OrderBookLevel]()


@value
struct Orderbook:
    var symbol: String
    var _asks: UnsafePointer[c_void_ptr]
    var _bids: UnsafePointer[c_void_ptr]

    fn __init__(out self, symbol: String):
        self.symbol = symbol
        self._asks = UnsafePointer[c_void_ptr].alloc(1)
        self._bids = UnsafePointer[c_void_ptr].alloc(1)

    fn __del__(owned self):
        self._asks.free()
        self._bids.free()

    fn on_update_orderbook(
        self,
        symbol: String,
        snapshot: Bool,
        inout asks: List[OrderBookLevel],
        inout bids: List[OrderBookLevel],
    ) raises:
        var index = 0
        if snapshot:
            seq_skiplist_free(self._asks[index])
            seq_skiplist_free(self._bids[index])
            self._asks[index] = seq_skiplist_new(True)
            self._bids[index] = seq_skiplist_new(False)

        var _asks = self._asks[index]
        for i in asks:
            # logd("ask price: " + str(i.price) + " qty: " + str(i.qty))
            if i[].qty.is_zero():
                _ = seq_skiplist_remove(_asks, i[].price.value())
            else:
                _ = seq_skiplist_insert(
                    _asks, i[].price.value(), i[].qty.value(), True
                )

        var _bids = self._bids[index]
        for i in bids:
            # logd("bid price: " + str(i.price) + " qty: " + str(i.qty))
            if i[].qty.is_zero():
                _ = seq_skiplist_remove(_bids, i[].price.value())
            else:
                _ = seq_skiplist_insert(
                    _bids, i[].price.value(), i[].qty.value(), True
                )

    fn get_orderbook(self, n: Int) raises -> OrderBookLite:
        var index: Int = 0  # self._symbol_index_dict[symbol]
        var ob = OrderBookLite(symbol=self.symbol)

        var _asks = self._asks[index]
        var _bids = self._bids[index]

        var a_node = seq_skiplist_begin(_asks)
        var a_end = seq_skiplist_end(_asks)
        var a_count: Int = 0

        while a_node != a_end:
            var key: Int64 = 0
            var value: Int64 = 0
            seq_skiplist_node_value(
                a_node,
                UnsafePointer[Int64].address_of(key),
                UnsafePointer[Int64].address_of(value),
            )
            var key_ = Fixed.from_value(key)
            var value_ = Fixed.from_value(value)
            # print("key: " + str(key_) + " value: " + str(value_))
            ob.asks.append(OrderBookLevel(key_, value_))
            a_count += 1
            if a_count >= n:
                break
            a_node = seq_skiplist_next(_asks, a_node)

        var b_node = seq_skiplist_begin(_bids)
        var b_end = seq_skiplist_end(_bids)
        var b_count: Int = 0

        while b_node != b_end:
            var key: Int64 = 0
            var value: Int64 = 0
            seq_skiplist_node_value(
                b_node,
                UnsafePointer[Int64].address_of(key),
                UnsafePointer[Int64].address_of(value),
            )
            var key_ = Fixed.from_value(key)
            var value_ = Fixed.from_value(value)
            # print("key: " + str(key_) + " value: " + str(value_))
            ob.bids.append(OrderBookLevel(key_, value_))
            b_count += 1
            if b_count >= n:
                break
            b_node = seq_skiplist_next(_bids, b_node)

        return ob
