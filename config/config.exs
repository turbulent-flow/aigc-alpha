# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :aigc_alpha,
  namespace: AIGCAlpha,
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :aigc_alpha, AIGCAlphaWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [json: AIGCAlphaWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: AIGCAlpha.PubSub,
  live_view: [signing_salt: "lPUhh7Uu"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :tesla, adapter: Tesla.Adapter.Mint

config :aigc_alpha, :wen_xin, adapter: AIGCAlpha.AIGCClient.WenXin

env = config_env()

if "#{env}.exs" |> Path.expand(__DIR__) |> File.exists?() do
  import_config "#{env}.exs"

  if "#{env}.secret.exs" |> Path.expand(__DIR__) |> File.exists?() do
    import_config "#{env}.secret.exs"
  end
end
