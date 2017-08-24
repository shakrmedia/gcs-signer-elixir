defmodule GcsSigner.Client do
  @moduledoc """
  Holds Google Cloud Service Account JSON
  """

  defstruct private_key: nil, client_email: nil

  @doc """
  Initialize GcsSigner.Client from given keyfile.

  ## Examples

      iex> service_account = service_account_json_str |> Poison.decode!
      iex> GcsSigner.Client.from_keyfile(service_account)
      %GcsSigner.Client{...}

  """
  def from_keyfile(%{
    "private_key" => private_key,
    "client_email" => client_email,
  }) do
    %GcsSigner.Client{
      private_key: private_key,
      client_email: client_email
    }
  end
end
