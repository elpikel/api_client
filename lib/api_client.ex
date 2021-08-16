defmodule ApiClient do
  alias ApiClient.AccessTokenCache
  alias ApiClient.HttpClient

  def get_data do
    access_token = AccessTokenCache.get()

    HttpClient.get("protected_data", access_token.token)
  end
end
