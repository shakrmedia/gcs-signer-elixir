defmodule GcsSignerTest do
  use ExUnit.Case
  alias GcsSigner.Client

  @bucket "bucket_name"
  @filename "object.mp4"
  @config_sample "test/gcs_config_sample.json"

  def fixture(_) do
    with {:ok, content} <- File.read(@config_sample) do
      Jason.decode(content)
    end
  end

  describe "sign_url/4" do
    setup :fixture

    test "ok", context do
      client = Client.from_keyfile(context)
      signed_url = GcsSigner.sign_url(client, @bucket, @filename)

      signed_url_parts = URI.parse(signed_url)

      query_string =
        signed_url_parts
        |> Map.fetch!(:query)
        |> URI.decode_query()

      assert "/#{@bucket}/#{@filename}" == Map.get(signed_url_parts, :path)
      assert is_map(query_string)
      assert Map.get(query_string, "GoogleAccessId", false)
      assert Map.get(context, "client_email") == Map.get(query_string, "GoogleAccessId")
      assert Map.get(query_string, "Signature", false)
    end
  end
end
