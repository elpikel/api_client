import Config

config :api_client,
  http_client_module: ApiClient.HttpClient,
  base_url: "localhost:4000"

import_config "#{Mix.env()}.exs"
