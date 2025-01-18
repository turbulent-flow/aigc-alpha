import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :aigc_alpha, AIGCAlphaWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "7O9MKH1bsYfBflgw9KpTUWH0sVO0qyUrSikWdzHSIkuCOMcA1FjHRbEZIPuo9DoW",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :tesla, adapter: Tesla.Mock

config :aigc_alpha, :aigc_client,
  adapter: AIGCAlpha.AIGCClientMock,
  api_key: "fake-key",
  model: "fake-model",
  basic_url: "https://example.com",
  inquire_path: "/fake-path"
