defmodule ApiClient.AccessTokenTest do
  use ExUnit.Case

  alias ApiClient.AccessToken
  alias ApiClient.AccessTokenCache

  describe "valid?" do
    test "is valid when is not expired" do
      access_token = %AccessToken{
        token: "token",
        expires_at: DateTime.add(DateTime.utc_now(), 120)
      }

      assert AccessToken.valid?(access_token)
    end

    test "is not valid when is expired" do
      access_token = %AccessToken{
        token: "token",
        expires_at: DateTime.utc_now()
      }

      refute AccessToken.valid?(access_token)
    end
  end

  describe "get" do
    @access_token "{\"access_token\":\"eyJhbG\", \"expires_in\":100}"

    setup do
      bypass = Bypass.open(port: 50_123)

      {:ok, _pid} = start_supervised({AccessTokenCache, [name: AccessTokenCache]})

      {:ok, bypass: bypass}
    end

    test "maps response to access token", %{bypass: bypass} do
      Bypass.expect(bypass, "GET", "/token", fn conn ->
        Plug.Conn.resp(conn, 200, @access_token)
      end)

      access_token = AccessToken.get()

      assert %AccessToken{token: "eyJhbG", expires_at: expires_at} = access_token

      assert DateTime.compare(DateTime.utc_now(), expires_at) == :lt
    end
  end
end
