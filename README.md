## 项目简介
该项目是 AIGC 的聊天应用的服务端，使用 elixir 编写 tcp server。该部分负责选择大语言模型，并与之交互；在收到客户端的指令后，向选择的模型接口发起垂询，再把结果返回给客户端。它的领域模型请参考[链接](https://github.com/turbulent-flow/aigc-web/blob/main/AIGC%20%E9%A2%86%E5%9F%9F%E6%A8%A1%E5%9E%8B.pdf)。

## 本地启动
### 1. 安装依赖
```shell
mix setup
```

### 2. 配置环境变量
在项目目录`\config`中放置`dev.secret.exs`，内容如下：
```elixir
import Config

config :aigc_alpha, :aigc_client,
  api_key: "LLM_API_KEY",
  model: "LLM_MODEL",
  basic_url: "LLM_BASIC_URL",
  inquire_path: "LLM_INQUIRE_PATH"
```
示例：文心一言
```elixir
config :aigc_alpha, :aigc_client,
  api_key: "WINXIN_API_KEY",
  model: "ernie-speed-pro-128k",
  basic_url: "https://qianfan.baidubce.com",
  inquire_path: "/v2/chat/completions"
```

### 3. 运行服务
```shell
iex -S mix
```
服务开启后，再在客户端发起指令。（启动 aigc-web，调用垂询接口）

## 测试
```shell
mix test
```
