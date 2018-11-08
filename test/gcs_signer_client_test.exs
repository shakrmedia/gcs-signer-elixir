defmodule GcsSignerClientTest do
  use ExUnit.Case
  alias GcsSigner.Client

  @config_sample "test/gcs_config_sample.json"

  def fixture(_) do
    with {:ok, content} <- File.read(@config_sample) do
      Jason.decode(content)
    end
  end

  describe "from_keyfile/1" do
    setup :fixture

    test "ok", context do
      client = Client.from_keyfile(context)

      refute is_nil(client)
      refute is_nil(client.private_key)
      refute is_nil(client.client_email)
    end

    test "fail" do
      assert :error == Client.from_keyfile(%{"random_key" => "random_value"})
    end
  end
end
