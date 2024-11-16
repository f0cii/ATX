# atx

```bash
magic shell
source init.sh

# 稳定版
# export LD_PRELOAD=./libatx-classic.so
LD_PRELOAD=./libatx-classic.so mojo test test_bybitclientjson.mojo

LD_PRELOAD=./libatx-classic.so mojo run atx-classic-demo.mojo

LD_PRELOAD=./libatx-classic.so mojo run atx-demo.mojo

LD_PRELOAD=./libatx-classic.so mojo run bybit-demo.mojo

# 测试版
LD_PRELOAD=./libatx-classic.so mojo run atx-demo.mojo

# 安装mojo vs code插件
rm -rf /home/yl/.cursor-server/data/User/globalStorage/modular-mojotools.vscode-mojo-nightly
```
