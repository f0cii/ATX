from memory import UnsafePointer
from time import sleep
from collections import Optional, Dict, List
from python import Python

from atxs_classic import *
from atxs_classic.websocket import (
    register_websocket,
    TLS1_3_VERSION,
    on_connected_callback,
    on_before_reconnect_callback,
    on_heartbeat_callback,
    on_message_callback,
    set_on_connected,
    set_on_before_reconnect,
    set_on_heartbeat,
    set_on_message,
    WebSocket,
)

from .subscriptions import DEFAULT_SUBS, NO_SYMBOL_SUBS
from .api_key import generate_nonce, generate_signature


# https://github.com/joliveros/bitmex-websocket/tree/master/bitmex_websocket


# Naive implementation of connecting to BitMEX websocket for streaming realtime data.
# The Marketmaker still interacts with this as if it were a REST Endpoint, but now it can get
# much more realtime data without polling the hell out of the API.
#
# The Websocket offers a bunch of data as raw properties right on the object.
# On connect, it synchronously asks for a push of all this data then returns.
# Right after, the MM can start using its data. It will be updated in realtime, so the MM can
# poll really often if it wants.
struct BitMEXWebsocket:
    # Don't grow a table larger than this amount. Helps cap memory usage.
    alias MAX_TABLE_LEN: Int = 200
    var endpoint: String
    var symbol: String
    var api_key: Optional[String]
    var api_secret: Optional[String]
    var exited: Bool
    var data: Dict[String, Bool]
    var ws: UnsafePointer[WebSocket]

    fn __init__(
        inout self,
        endpoint: String,
        symbol: String,
        api_key: Optional[String] = None,
        api_secret: Optional[String] = None,
        subscriptions: List[String] = DEFAULT_SUBS,
    ) raises:
        """Connect to the websocket and initialize data stores."""
        # self.logger = logging.getLogger(__name__)
        # self.logger.debug("Initializing WebSocket.")
        self.endpoint = endpoint
        self.symbol = symbol

        if api_key is not None and api_secret is None:
            raise Error("api_secret is required if api_key is provided")
        if api_key is None and api_secret is not None:
            raise Error("api_key is required if api_secret is provided")

        self.api_key = api_key
        self.api_secret = api_secret

        self.data = Dict[String, Bool]()
        # self.data: dict[str, list[object]] = {}
        # self.keys: dict[str, object] = {}
        self.exited = False

        # We can subscribe right in the connection querystring, so let's build that.
        # Subscribe to all pertinent endpoints
        var ws_url = self.__get_url(endpoint, symbol, subscriptions)
        # var host = ""
        # var port = ""
        # var path = ""
        logi("Connecting to " + ws_url)
        self.ws = UnsafePointer[WebSocket].alloc(1)
        # self.ws = WebSocket(host=host, port=port, path=path)
        self.__connect(ws_url, symbol)
        # self.logger.info("Connected to WS.")

        # Connected. Wait for partials
        self.__wait_for_symbol(symbol)
        if api_key:
            self.__wait_for_account()
        # self.logger.info("Got all market data. Starting.")

    fn exit(out self):
        """Call this to exit - will close websocket."""
        self.exited = True
        self.ws[].close()

    fn get_instrument(self) -> String:
        """Get the raw instrument data for this symbol."""
        # Turn the 'tickSize' into 'tickLog' for use in rounding
        # var instrument = self.data["instrument"][0]
        # instrument["tickLog"] = int(math.fabs(math.log10(instrument["tickSize"])))
        # return instrument
        # TODO: 2
        return ""

    fn get_ticker(self) -> String:
        # """Return a ticker object. Generated from quote and trade."""
        # lastQuote = self.data["quote"][-1]
        # lastTrade = self.data["trade"][-1]
        # ticker = {
        #     "last": lastTrade["price"],
        #     "buy": lastQuote["bidPrice"],
        #     "sell": lastQuote["askPrice"],
        #     "mid": (
        #         float(lastQuote["bidPrice"] or 0) + float(lastQuote["askPrice"] or 0)
        #     )
        #     / 2,
        # }

        # # The instrument has a tickSize. Use it to round values.
        # instrument = self.data["instrument"][0]
        # return {
        #     k: round(float(v or 0), instrument["tickLog"]) for k, v in ticker.items()
        # }
        return ""

    fn funds(self) -> String:
        # """Get your margin details."""
        # return self.data["margin"][0]
        # TODO: 1
        return ""

    fn positions(self) -> String:
        """Get your positions."""
        # TODO: 1
        # return self.data["position"]
        return ""

    fn market_depth(self) -> String:
        """Get market depth (orderbook). Returns all levels."""
        # return self.data["orderBookL2"]
        # TODO: 1
        return ""

    fn open_orders(self, clOrdIDPrefix: String):
        """Get all your open orders."""
        # orders = self.data["order"]
        # # Filter to only open orders and those that we actually placed
        # return [
        #     o
        #     for o in orders
        #     if str(o["clOrdID"]).startswith(clOrdIDPrefix) and order_leaves_quantity(o)
        # ]
        return

    fn recent_trades(self) -> String:
        """Get recent trades."""
        # TODO: 1
        # return self.data["trade"]
        return ""

    #
    # End Public Methods
    #

    fn __connect(out self, ws_url: String, symbol: String) raises:
        """Connect to the websocket in a thread."""
        # self.logger.debug("Starting thread")

        # self.wst = threading.Thread(target=lambda: self.ws.run_forever())
        # self.wst.daemon = True
        # self.wst.start()
        # self.logger.debug("Started thread")

        # Wait for connect before continuing
        # var conn_timeout = 5
        # while not self.ws.connected() and conn_timeout > 0:
        #     sleep(1)
        #     conn_timeout -= 1
        # if not conn_timeout:
        #     # self.logger.error("Couldn't connect to WS! Exiting.")
        #     self.exit()
        #     # raise websocket.WebSocketTimeoutException(
        #     #     "Couldn't connect to WS! Exiting."
        #     # )
        #     raise Error("Couldn't connect to WS! Exiting.")
        # var wsURL = self.__get_url(self.endpoint, symbol, subscriptions)

        var headers = self.__get_auth()
        # wss://ws.testnet.bitmex.com/realtime?subscribe=execution,instrument,margin,order,orderBookL2,position,quote,trade
        var parse = Python.import_module("urllib.parse")
        var parsed_url = parse.urlparse(ws_url)
        # ParseResult(scheme='wss', netloc='ws.testnet.bitmex.com', path='/realtime', params='', query='subscribe=execution,instrument,margin,order,orderBookL2,position,quote,trade', fragment='')
        # print(parsed_url)
        var host = str(parsed_url.netloc)
        var port = "443"  # int(parsed_url.port) if parsed_url.port != 0 else (443 if parsed_url.scheme == "wss" else 80)
        var path = str(parsed_url.path) + "?" + str(
            parsed_url.query
        ) if parsed_url.query != "" else str(parsed_url.path)
        # print(host)
        # print(port)
        # print(path)
        # var host = ""
        # var port = ""
        # var path = ""
        self.ws[0] = WebSocket(host=host, port=str(port), path=path)

        var id = self.ws[].get_id()

        var on_connect = self.get_on_connected()
        var on_heartbeat = self.get_on_heartbeat()
        var on_before_reconnect = self.get_on_before_reconnect()
        var on_message = self.get_on_message()

        set_on_connected(id, on_connect^)
        set_on_before_reconnect(id, on_before_reconnect^)
        set_on_heartbeat(id, on_heartbeat^)
        set_on_message(id, on_message^)

        self.ws[].set_headers(headers)
        self.ws[].connect()

    fn __get_auth(self) -> Dict[String, String]:
        """Return auth headers. Will use API Keys if present in settings."""
        if self.api_key:
            # self.logger.info("Authenticating with API Key.")
            # To auth to the WS using an API key, we generate a signature of a nonce and
            # the WS API endpoint.
            var expires = generate_nonce()
            var dict = Dict[String, String]()
            dict["api-expires"] = str(expires)
            dict["api-signature"] = generate_signature(
                self.api_secret.value(), "GET", "/realtime", expires, ""
            )
            dict["api-key"] = self.api_key.value()
            return dict
        else:
            # self.logger.info("Not authenticating.")
            return Dict[String, String]()

    @staticmethod
    fn __get_url(
        endpoint: String, symbol: String, subscriptions: List[String]
    ) -> String:
        """
        Generate a connection URL. We can define subscriptions right in the querystring.
        Most subscription topics are scoped by the symbol we're listening to.
        """

        # wss://ws.testnet.bitmex.com/realtime?subscribe=execution,instrument,margin,order,orderBookL2,position,quote,trade

        var subscriptions_ = List[String]()

        for i in subscriptions:
            var sub = i[]
            # logi("sub=" + sub)
            if sub in NO_SYMBOL_SUBS:
                subscriptions_.append(sub)
            else:
                subscriptions_.append(sub + ":" + symbol)

        # Some subscriptions need to have the symbol appended.
        # subscriptions_full = map(
        #     lambda sub: (sub if sub in NO_SYMBOL_SUBS else (sub + ":" + self.symbol)),
        #     subscriptions,
        # )
        var subscriptions_full = String(",").join(subscriptions_)
        return endpoint + "?subscribe=" + subscriptions_full

        # urlParts = list(urllib.parse.urlparse(self.endpoint))
        # urlParts[2] += "?subscribe={}".format(",".join(subscriptions_full))
        # return urllib.parse.urlunparse(urlParts)

    fn __wait_for_account(self):
        """On subscribe, this data will come down. Wait for it."""
        # Wait for the keys to show up from the ws
        # while not {"margin", "position", "order", "orderBookL2"} <= set(self.data):
        #     sleep(0.1)
        pass

    fn __wait_for_symbol(self, symbol: String):
        """On subscribe, this data will come down. Wait for it."""
        # while not {"instrument", "trade", "quote"} <= set(self.data):
        #     sleep(0.1)
        pass

    # fn __send_command(self, command: String, args: List[String]):
    #     """Send a raw command."""
    #     # if args is None:
    #     #     args = []
    #     self.ws.send(json.dumps({"op": command, "args": args}))

    fn get_on_connected(self) -> on_connected_callback:
        var self_ptr = UnsafePointer.address_of(self)

        fn wrapper():
            self_ptr[].__on_connected()

        return wrapper

    fn get_on_heartbeat(self) -> on_heartbeat_callback:
        var self_ptr = UnsafePointer.address_of(self)

        fn wrapper():
            self_ptr[].__on_heartbeat()

        return wrapper

    fn get_on_before_reconnect(self) -> on_before_reconnect_callback:
        var self_ptr = UnsafePointer.address_of(self)

        fn wrapper():
            self_ptr[].__on_before_reconnect()

        return wrapper

    fn get_on_message(self) -> on_message_callback:
        var self_ptr = UnsafePointer.address_of(self)

        fn wrapper(msg: String):
            self_ptr[].__on_message(msg)

        return wrapper

    fn __on_connected(self):
        logi("__on_connected")

    fn __on_before_reconnect(self) -> None:
        logi("__on_before_reconnect")
        var headers = self.__get_auth()
        self.ws[].set_headers(headers)

    fn __on_heartbeat(self):
        logi("__on_heartbeat")

    fn __on_message(self, message: String) -> None:
        """Handler for parsing WS messages."""
        # logi("message: " + message)
        pass
        # message = json.loads(message)
        # self.logger.debug(json.dumps(message))

        # table = message.get("table")
        # action = message.get("action")
        # try:
        #     if "subscribe" in message:
        #         self.logger.debug("Subscribed to %s." % message["subscribe"])
        #     elif action:
        #         if table not in self.data:
        #             self.data[table] = []

        #         # There are four possible actions from the WS:
        #         # 'partial' - full table image
        #         # 'insert'  - new row
        #         # 'update'  - update row
        #         # 'delete'  - delete row
        #         if action == "partial":
        #             self.logger.debug("%s: partial" % table)
        #             self.data[table] = message["data"]
        #             # Keys are communicated on partials to let you know how to uniquely identify
        #             # an item. We use it for updates.
        #             self.keys[table] = message["keys"]
        #         elif action == "insert":
        #             self.logger.debug("%s: inserting %s" % (table, message["data"]))
        #             self.data[table] += message["data"]

        #             # Limit the max length of the table to avoid excessive memory usage.
        #             # Don't trim orders because we'll lose valuable state if we do.
        #             if (
        #                 table not in ["order", "orderBookL2"]
        #                 and len(self.data[table]) > BitMEXWebsocket.MAX_TABLE_LEN
        #             ):
        #                 self.data[table] = self.data[table][
        #                     BitMEXWebsocket.MAX_TABLE_LEN // 2 :
        #                 ]

        #         elif action == "update":
        #             self.logger.debug("%s: updating %s" % (table, message["data"]))
        #             # Locate the item in the collection and update it.
        #             for updateData in message["data"]:
        #                 item = find_by_keys(
        #                     self.keys[table], self.data[table], updateData
        #                 )
        #                 if not item:
        #                     return  # No item found to update. Could happen before push
        #                 item.update(updateData)
        #                 # Remove cancelled / filled orders
        #                 if table == "order" and not order_leaves_quantity(item):
        #                     self.data[table].remove(item)
        #         elif action == "delete":
        #             self.logger.debug("%s: deleting %s" % (table, message["data"]))
        #             # Locate the item in the collection and remove it.
        #             for deleteData in message["data"]:
        #                 item = find_by_keys(
        #                     self.keys[table], self.data[table], deleteData
        #                 )
        #                 self.data[table].remove(item)
        #         else:
        #             raise Exception("Unknown action: %s" % action)
        # except:
        #     self.logger.error(traceback.format_exc())

    fn __on_error(self, ws: Int, error: String):
        """Called on fatal websocket errors. We exit on these."""
        # if not self.exited:
        #     self.logger.error("Error : %s" % error)
        #     raise websocket.WebSocketException(error)
        pass

    fn __on_open(self, ws: Int):
        """Called when the WS opens."""
        logi("Websocket Opened.")

    fn __on_close(self, ws: Int, status_code: Int, msg: String):
        """Called on websocket close."""
        logi("Websocket Closed")


# Utility method for finding an item in the store.
# When an update comes through on the websocket, we need to figure out which item in the array it is
# in order to match that item.
#
# Helpfully, on a data push (or on an HTTP hit to /api/v1/schema), we have a "keys" array. These are the
# fields we can use to uniquely identify an item. Sometimes there is more than one, so we iterate through all
# provided keys.
# fn find_by_keys(keys, table, matchData):
#     for item in table:
#         if all(item[k] == matchData[k] for k in keys):
#             return item


# fn order_leaves_quantity(o):
#     if o["leavesQty"] is None:
#         return True
#     return o["leavesQty"] > 0
