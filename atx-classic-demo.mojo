import time
from testing import assert_equal, assert_true
from os import getenv
from time import now
from random import randn_float64, random_float64, random_si64, random_ui64, seed
from atxs_classic import *
from atxs_classic.httpclient import HttpClient as HttpClientClassic, Headers, VERB_GET


fn test_httpclient_classic() raises:
    var base_url = "https://www.baidu.com"
    # var base_url = "https://api.bybit.com"
    # https://api.bybit.com/v3/public/time
    var client = HttpClientClassic(base_url)
    var headers = Headers()
    headers["a"] = "abc"
    var response = client.get("/v3/public/time", headers)
    print(response.text)

# cp ~/f0cii/echo-cpp2/build/linux/x86_64/release/libecho2.so ~/mojo/echo/
# export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(realpath .)
# export LD_PRELOAD=./libecho2.so
# mojo test test_echo2.mojo


fn main() raises -> None:
    _ = seq_ct_init()
    test_httpclient_classic()

    # while True:
    #     time.sleep(1000)
    # export LD_LIBRARY_PATH=/usr/lib:$LD_LIBRARY_PATH:$(realpath .magic/envs/default/lib)
    # export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(realpath /usr/lib .magic/envs/default/lib)
