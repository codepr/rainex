import Config

config :rainex,
  http_client: Rainex.Http.Client,
  owm_token: System.get_env("OWM_TOKEN")
