import asyncio
from gateio.futures_client import FutureClient


async def main():
    api_key = "10d23703c09150b1bf4c5bb7f0f1dd2e"
    api_secret = "996c14c32700f3ce63d0f5530793766a7b8bda8cdfaf5d71071915235f3d3f50"
    # domain = "https://api.gateio.ws/api/v4"
    domain = "https://fx-api-testnet.gateio.ws/api/v4"

    # wss://fx-ws-testnet.gateio.ws/v4/ws/btc
    # https://www.gate.io/docs/developers/apiv4/

    # Live trading: https://api.gateio.ws/api/v4
    # Futures TestNet trading: https://fx-api-testnet.gateio.ws/api/v4
    # Futures live trading alternative (futures only): https://fx-api.gateio.ws/api/v4
    # Initialize the FutureClient with your API key and secret

    # REST API BaseURL:

    # 实盘交易: https://api.gateio.ws/api/v4
    # 合约模拟交易: https://fx-api-testnet.gateio.ws/api/v4
    # 合约实盘交易备选入口（只适用合约 API）：https://fx-api.gateio.ws/api/v4
    client = FutureClient(apikey=api_key, apisecret=api_secret, domain=domain)

    settle = "usdt"
    contract = "BTC_USDT"

    # # Example: Get contracts for a specific settlement
    # # settle = "BTC"
    # contracts, error = await client.get_contracts(settle)
    # if error:
    #     print(f"Error fetching contracts: {error}")
    # else:
    #     print("Contracts:", contracts)

    # # Example: Get order book for a specific contract
    # order_book, error = await client.get_order_book(settle, contract, "5")
    # if error:
    #     print(f"Error fetching order book: {error}")
    # else:
    #     print("Order Book:", order_book)

    # # Example: Get trades for a specific contract
    # trades, error = await client.get_trades(settle, contract)
    # if error:
    #     print(f"Error fetching trades: {error}")
    # else:
    #     print("Trades:", trades)

    # 下单
    orderParam = {
        "contract": "BTC_USDT",
        "size": 6024,
        "iceberg": 0,
        "price": "53765",
        "tif": "gtc",
        "text": "t-my-custom-id",
        "stp_act": "-",
    }
    # {"contract":symbol,"size":size,"price": price,"tif": tif,"close": close,"auto_size":auto_size,"reduce_only":reduce_only}
    # res, error = await client.place_order(settle, orderParam)
    # if error:
    #     print(f"Error place order: {error}")
    # else:
    #     print(res)
    # {'refu': 0, 'tkfr': '0.0005', 'mkfr': '0.0002', 'contract': 'BTC_USDT', 'id': 3986224102, 'price': '53765', 'tif': 'gtc', 'iceberg': 0, 'text': 't-my-custom-id', 'user': 16792411, 'is_reduce_only': False, 'is_close': False, 'is_liq': False, 'fill_price': '0', 'create_time': 1728697881.701, 'update_time': 1728697881.701, 'status': 'open', 'left': 6024, 'refr': '0', 'size': 6024, 'biz_info': 'ch:daniugege', 'amend_text': '-', 'stp_act': '-', 'stp_id': 0, 'update_id': 1, 'pnl': '0', 'pnl_margin': '0'}
    
    res, error = await client.get_futures_orders(settle, "open")
    print(res)


if __name__ == "__main__":
    asyncio.run(main())
