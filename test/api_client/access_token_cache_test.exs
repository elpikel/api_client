defmodule ApiClient.AccessTokenCacheTest do
  use ExUnit.Case

  alias ApiClient.AccessTokenCache

  @access_token "{\"access_token\":\"eyJhbG\", \"expires_in\":100}"

  setup do
    bypass = Bypass.open(port: 50_123)

    {:ok, _pid} = start_supervised({AccessTokenCache, [name: AccessTokenCache]})

    {:ok, bypass: bypass}
  end

  describe "get" do
    test "fetches access token when there is none in cache", %{bypass: bypass} do
      Bypass.expect(bypass, fn conn ->
        Plug.Conn.resp(conn, 200, @access_token)
      end)

      access_token = AccessTokenCache.get()
      assert access_token.token == "eyJhbG"
    end

    test "gets access token from cache", %{bypass: bypass} do
      Bypass.expect_once(bypass, fn conn ->
        Plug.Conn.resp(conn, 200, @access_token)
      end)

      access_token = AccessTokenCache.get()
      assert access_token.token == "eyJhbG"

      new_access_token = AccessTokenCache.get()
      assert access_token.token == new_access_token.token
    end

    test "fetches access token when is expired", %{bypass: bypass} do
      Bypass.expect(bypass, fn conn ->
        Plug.Conn.resp(conn, 200, "{\"access_token\":\"#{random_string(8)}\", \"expires_in\":1}")
      end)

      access_token = AccessTokenCache.get()

      Process.sleep(1000)

      new_access_token = AccessTokenCache.get()
      assert access_token.token != new_access_token.token
    end

    test "returns error when api is down", %{bypass: bypass} do
      Bypass.down(bypass)

      :error = AccessTokenCache.get()
    end
  end

  defp random_string(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64() |> binary_part(0, length)
  end
end
