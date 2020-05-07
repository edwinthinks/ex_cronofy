use Mix.Config

config :ex_cronofy,
  debug_requests: true,
  client_id: [{:system, "CRONOFY_CLIENT_ID"}, :instance_role],
  redirect_uri: [{:system, "CRONOFY_REDIRECT_URI"}, :instance_role]
