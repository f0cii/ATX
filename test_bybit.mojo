from core.bybitclient import *
from core.binanceclient import *
from core.binancews import *


fn test_bybit_client() raises:
    var client = BybitClient(testnet=True, access_key="", secret_key="")
    # var res = client.fetch_public_time()
    # logi(str(res))


fn test_binance_client() raises:
    var client = BinanceClient(testnet=True, access_key="", secret_key="")
    # var res = client.fetch_public_time()
    # logi(str(res))


fn test_binance_ws() raises:
    var ws = BinanceWS(False, testnet=True, access_key="", secret_key="")
