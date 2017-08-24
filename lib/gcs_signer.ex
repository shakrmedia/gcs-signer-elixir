defmodule GcsSigner do
  @moduledoc """
  Documentation for GcsSigner.
  """

  @doc """
  Hello world.

  ## Examples

      iex> GcsSigner.sign_url("my-bucket", "my-object.mp4", expires: 1503599316)
      "https://storage.googleapis.com/my-bucket/my-object.mp4?Expires=15..."

  """

  @base_url "https://storage.googleapis.com"

  def sign_url(client, bucket, key, opts \\ []) do
    verb = opts[:verb] || "GET"
    md5_digest = opts[:md5_digest] || ""
    content_type = opts[:content_type] || ""
    expires = opts[:expires] || hours_after(1)
    resource = "/#{bucket}/#{key}"

    signature = [verb, md5_digest, content_type, expires, resource]
                |> Enum.join("\n") |> generate_signature(client)

    url = "#{@base_url}#{resource}"
    qs = %{
      "GoogleAccessId" => client.client_email,
      "Expires" => expires,
      "Signature" => signature
    } |> URI.encode_query

    Enum.join([url, "?", qs])
  end

  def hours_after(hour) do
    DateTime.utc_now() |> DateTime.to_unix() |> Kernel.+(hour * 3600)
  end

  defp generate_signature(string, client) do
    private_key = get_private_key(client)

    string
    |> :public_key.sign(:sha256, private_key)
    |> Base.encode64
  end

  # Derive private key from Google Cloud Service Account
  # Idea for this code is mostly from this GitHub issue:
  # https://github.com/potatosalad/erlang-jose/issues/13#issuecomment-160718744
  def get_private_key(client) do
    client.private_key
    |> :public_key.pem_decode
    |> (fn [x] -> x end).()
    |> :public_key.pem_entry_decode
    |> elem(3) # grab privateKey from the record tuple
    |> (fn pk -> :public_key.der_decode(:RSAPrivateKey, pk) end).()
  end
end
