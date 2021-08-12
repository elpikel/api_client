defmodule ApiClient.HttpClient do
  alias ApiClient.Url

  def get(url, token \\ nil) do
    case HTTPoison.get(Url.new(url), header(token)) do
      {:ok, %HTTPoison.Response{body: body, status_code: 200}} ->
        Jason.decode!(body)

      _error ->
        :error
    end
  end

  defp header(nil) do
    [{"Content-Type", "application/json"}]
  end

  defp header(token) do
    [{"Authorization", "Bearer #{token}"} | header(nil)]
  end
end
