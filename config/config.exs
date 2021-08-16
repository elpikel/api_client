import Config

config :api_client,
  base_url: "http://localhost:4000/"

import_config "#{Mix.env()}.exs"
