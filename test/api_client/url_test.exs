defmodule ApiClient.UrlTest do
  use ExUnit.Case

  alias ApiClient.Url

  describe "new/1" do
    test "merges url with base" do
      url = Url.new("/test/url")

      assert "#{url}" == "http://localhost:50123/test/url"
    end
  end
end
