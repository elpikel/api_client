defmodule AccessTokenCache do
  use GenServer

  alias AccessToken

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def get(config) do
    GenServer.call(AccessTokenCache, {:get, config})
  end

  @impl true
  def init(:ok) do
    {:ok, nil}
  end

  @impl true
  def handle_call({:get, config}, _from, nil) do
    get_access_token(config)
  end

  def handle_call({:get, config}, _from, %AccessToken{} = access_token) do
    if AccessToken.valid?(access_token) do
      {:reply, {:ok, access_token}, access_token}
    else
      get_access_token(config)
    end
  end

  defp get_access_token(config) do
    case config.client_module.access_token(config) do
      {:ok, access_token} ->
        {:reply, {:ok, access_token}, access_token}

      error ->
        {:reply, error, nil}
    end
  end
end
