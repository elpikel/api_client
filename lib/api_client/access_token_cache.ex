defmodule ApiClient.AccessTokenCache do
  use GenServer

  alias ApiClient.AccessToken

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def get() do
    GenServer.call(__MODULE__, :get)
  end

  @impl true
  def init(:ok) do
    {:ok, nil}
  end

  @impl true
  def handle_call(:get, _from, nil) do
    get_access_token()
  end

  def handle_call(:get, _from, %AccessToken{} = access_token) do
    if AccessToken.valid?(access_token) do
      {:reply, access_token, access_token}
    else
      get_access_token()
    end
  end

  defp get_access_token() do
    access_token = AccessToken.get()

    {:reply, access_token, access_token}
  end
end
