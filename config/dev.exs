use Mix.Config

config :ex_cronofy,
  debug_requests: true,
  client_id: System.get_env("CRONOFY_CLIENT_ID"),
  client_secret: System.get_env("CRONOFY_CLIENT_SECRET"),
  redirect_uri: System.get_env("CRONOFY_REDIRECT_URI")
