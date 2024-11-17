from time import now
from core.bybitclient import *
from core.bybitws import *
from core.binanceclient import *
from core.binancews import *


fn sum_int_list(v: List[Int]) raises -> Int:
    var result: Int = 0
    for item in v:
        result += item[]
    return result


# fn test_bybit_client() raises:
#     var client = BybitClient(testnet=True, access_key="", secret_key="")
#     # var res = client.fetch_public_time()
#     var res = client.fetch_orderbook(symbol="BTCUSDT")
#     logi(str(res))


fn test_bybitclient() raises:
    # var app_config = load_config("config.toml")

    var access_key = ""
    var secret_key = ""
    var testnet = False
    var client = BybitClient(
        testnet=testnet, access_key=access_key, secret_key=secret_key
    )

    # client.set_verbose(True)

    # Preparation phase
    var server_time = client.fetch_public_time()
    logi(str(server_time))
    # _ = seq_photon_thread_sleep_ms(200)

    var category = "linear"
    # var symbol = "BTCUSDT"
    var symbol = "XRPUSDT"

    var exchange_info = client.fetch_exchange_info(category, symbol)
    logi(str(exchange_info))

    # <ExchangeInfo: symbol=BTCUSDT, tick_size=0.10000000000000001, step_size=0.001>

    var kline = client.fetch_kline(
        category, symbol, interval="1", limit=5, start=0, end=0
    )
    for item in kline:
        logi(str(item[]))

    # test_orderbook_parse_body()
    var ob = client.fetch_orderbook(category, symbol, 5)
    logi("-----asks-----")
    for item in ob.asks:
        logi(str(item[]))

    logi("-----bids-----")
    for item in ob.bids:
        logi(str(item[]))

    # var switch_position_mode_res = client.switch_position_mode(
    #     category, symbol, "3"
    # )
    # logi("res=" + str(switch_position_mode_res))
    # retCode=1, retMsg=Open orders exist, so you cannot change position mode

    # var set_leverage_res = client.set_leverage(category, symbol, "10", "10")
    # logi("res=" + str(set_leverage_res))

    # var side = "Buy"
    # var order_type = "Limit"
    # var qty = "0.001"
    # var price = "3000"

    # var place_order_res = client.place_order(category, symbol, side, order_type, qty, price, position_idx=1)
    # logi("res=" + str(place_order_res))
    # # retCode=1, retMsg=params error: The number of contracts exceeds minimum limit allowed

    # var cancel_order_res = client.cancel_order(category, symbol, "4d822437-a502-49d6-8aa7-55a602920b3f")
    # logi("res=" + str(cancel_order_res))

    # var cancel_orders_res = client.cancel_orders(category, symbol)
    # for item in cancel_orders_res:
    #     logi("item=" + str(item))

    # var fetch_balance_res = client.fetch_balance("CONTRACT", "USDT")
    # for item in fetch_balance_res:
    #     logi("item=" + str(item))

    # var fetch_orders_res = client.fetch_orders(category, symbol)
    # for item in fetch_orders_res:
    #     logi("item=" + str(item))

    # var fetch_positions_res = client.fetch_positions(category, symbol)
    # for item in fetch_positions_res:
    #     logi("item=" + str(item))
    # <PositionInfo: symbol=BTCUSDT, position_idx=1, side=Buy, size=0.015, avg_price=40869.30666667, position_value=613.0396, leverage=1.0, mark_price=42191.30, position_mm=0.0000075, position_im=6.130396, take_profit=0.00, stop_loss=0.00, unrealised_pnl=19.8299, cum_realised_pnl=838.09142572, created_time=1682125794703, updated_time=1706790560723>

    # Close position
    # var side = "Buy"
    # var order_type = "Limit"
    # var qty = "0.001"
    # var price = "3000"

    # var res = client.place_order(category, symbol, "Sell", "Market", qty, "", position_idx=1)
    # logi("res=" + str(res))

    logi("Done!!!")


fn test_bybit_perf() raises:
    var access_key = ""
    var secret_key = ""
    var testnet = True
    var client = BybitClient(
        testnet=testnet, access_key=access_key, secret_key=secret_key
    )

    client.set_verbose(True)

    # Preparation phase
    var server_time = client.fetch_public_time()
    logi(str(server_time))
    # _ = seq_photon_thread_sleep_ms(200)

    var category = "linear"
    var symbol = "BTCUSDT"

    var side = "Buy"
    var order_type = "Limit"
    var qty = "0.001"
    var price = "10000"

    # Test order placement speed
    var times = 30
    var order_times = List[
        Int
    ]()  # Record the time taken for each order placement
    var cancel_times = List[
        Int
    ]()  # Record the time taken for each order cancellation

    var start_time = now()

    for i in range(times):
        # logi("i=" + str(i))

        var order_start = now()

        var res = client.place_order(
            category, symbol, side, order_type, qty, price, position_idx=1
        )

        var order_end = now()

        logi(
            str(i)
            + ":Place order returns="
            + str(res)
            + " Time consumption: "
            + str(order_end - order_start)
            + " us"
        )

        var order_id = res.order_id

        var cancel_start = now()

        var res1 = client.cancel_order(category, symbol, order_id)

        var cancel_end = now()

        logi(
            str(i)
            + ":Cancel order returns="
            + str(res1)
            + " Time consumption: "
            + str(cancel_end - cancel_start)
            + " us"
        )

        order_times.append(int(order_end - order_start))
        cancel_times.append(int(cancel_end - cancel_start))

        # _ = seq_photon_thread_sleep_ms(500)

    var end_time = now()

    var total_time = end_time - start_time

    logi("Total time consumed:" + str(total_time) + " us")

    logi(
        "Average time taken for order placement:"
        + str(sum_int_list(order_times) / len(order_times))
        + " us"
    )
    logi(
        "Average time taken for order cancellation:"
        + str(sum_int_list(cancel_times) / len(cancel_times))
        + " us"
    )

    logi("Done!!!")


fn on_message(s: String) -> None:
    logi("on_message: " + s)


fn test_bybitws() raises:
    logd("test_bybitws")
    var ws = BybitWS(
        is_private=False,
        testnet=False,
        access_key="",
        secret_key="",
        category="linear",
        topics="orderbook.1.BTCUSDT",
    )

    var on_connected = ws.get_on_connected()
    var on_heartbeat = ws.get_on_heartbeat()
    var on_message = ws.get_on_message()

    ws.set_on_connected(on_connected^)
    ws.set_on_heartbeat(on_heartbeat^)
    # ws.set_on_message(on_message^)
    ws.set_on_message(on_message)

    ws.set_verbose(True)

    ws.connect()

    logi("connect done")

    var ioc = seq_asio_ioc()
    seq_asio_run(ioc)

    _ = ws^


fn test_binance_client() raises:
    var client = BinanceClient(testnet=True, access_key="", secret_key="")
    # var res = client.fetch_public_time()
    # logi(str(res))


fn test_binance_ws() raises:
    var ws = BinanceWS(False, testnet=True, access_key="", secret_key="")
    # ws.start()


fn main() raises:
    seq_set_log_output_level(0)
    init_log("DBG", "")
    # test_bybitclient()
    test_bybitws()
    # test_binance_client()
    # test_binance_ws()

    # LD_PRELOAD=./lib/libatx-classic.so mojo run bybit-demo.mojo
