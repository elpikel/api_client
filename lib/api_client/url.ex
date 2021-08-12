defmodule ApiClient.Url do
  @base_url Application.fetch_env!(:api_client, :base_url)

  def new(url) do
    URI.merge(@base_url, url)
  end
end
