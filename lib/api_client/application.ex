defmodule ApiClient.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  alias ApiClient.AccessTokenCache

  def start(_type, _args) do
    children = [
      {AccessTokenCache, name: AccessTokenCache}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ApiClient.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
