defmodule ApiClient.AccessToken do
  @enforce_keys [:token, :expires_at]
  defstruct token: nil, expires_at: nil

  @http_client Application.fetch_env!(:api_client, :http_client_module)
  @token_url "token"

  def get do
    @token_url
    |> @http_client.get()
    |> new()
  end

  def valid?(%__MODULE__{} = access_token) do
    DateTime.compare(DateTime.add(access_token.expires_at, -60), DateTime.utc_now()) == :gt
  end

  defp new(response) do
    token = response["access_token"]
    expires_at = DateTime.add(DateTime.utc_now(), response["expires_in"])

    %__MODULE__{token: token, expires_at: expires_at}
  end
end
