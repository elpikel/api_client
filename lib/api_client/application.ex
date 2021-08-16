defmodule ApiClient.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  alias ApiClient.AccessTokenCache

  def start(_type, _args) do
    children =
      if Mix.env() == :test do
        []
      else
        [
          {AccessTokenCache, name: AccessTokenCache}
        ]
      end

    opts = [strategy: :one_for_one, name: ApiClient.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
