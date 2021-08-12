defmodule ApiClient do
  alias ApiClient.AccessTokenCache

  @http_client Application.fetch_env!(:api_client, :http_client_module)

  def get_data do
    access_token = AccessTokenCache.get()

    @http_client.get("protected_data", access_token.token)
  end
end
