defmodule GcsSigner do
  @moduledoc """
  Documentation for GcsSigner.
  """

  @base_url "https://storage.googleapis.com"

  @otp_greater_21? :erlang.system_info(:otp_release) >= '21'

  @type sign_url_opts :: [
    verb: String.t,
    md5_digest: String.t,
    content_type: String.t,
    expires: integer
  ]

  @doc """
  Generates signed url.

  ## Examples

      iex> client = GcsSigner.Client.from_keyfile("{...}")
      iex> GcsSigner.sign_url(client, "my-bucket", "my-object.mp4", expires: 1503599316)
      "https://storage.googleapis.com/my-bucket/my-object.mp4?Expires=15..."

  """
  @spec sign_url(
    %{client_email: String.t, private_key: String.t},
    String.t,
    String.t,
    sign_url_opts
  ) :: String.t
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

  @doc """
  Calculate future timestamp from given hour offset.

  ## Examples

      iex> 10 |> GcsSigner.hours_after
      1503599316

  """
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
  defp get_private_key(client) do
    client.private_key
    |> :public_key.pem_decode
    |> (fn [x] -> x end).()
    |> :public_key.pem_entry_decode
    |> normalize_private_key
  end

  defp normalize_private_key(private_key) do
    if @otp_greater_21? do
      # From OTP 21, GCS keys are correctly decoded and do not need any
      # extra treatment
      private_key
    else
      # grab privateKey from the record tuple
      private_key
      |> elem(3)
      |> (fn pk -> :public_key.der_decode(:RSAPrivateKey, pk) end).()
    end
  end
end
