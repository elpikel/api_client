defmodule ApiClientTest do
  use ExUnit.Case

  alias ApiClient.AccessTokenCache

  @access_token "{\"access_token\":\"eyJhbG\", \"expires_in\":100}"
  @protected_data "{\"data\": \"secret\"}"

  setup do
    bypass = Bypass.open(port: 50_123)

    {:ok, _pid} = start_supervised({AccessTokenCache, [name: AccessTokenCache]})

    {:ok, bypass: bypass}
  end

  test "get_data", %{bypass: bypass} do
    Bypass.expect(bypass, "GET", "/token", fn conn ->
      Plug.Conn.resp(conn, 200, @access_token)
    end)

    Bypass.expect(bypass, "GET", "/protected_data", fn conn ->
      Plug.Conn.resp(conn, 200, @protected_data)
    end)

    assert %{"data" => "secret"} == ApiClient.get_data()
  end
end
