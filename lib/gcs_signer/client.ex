defmodule GcsSigner.Client do
  @moduledoc """
  Holds Google Cloud Service Account JSON
  """

  @type t :: %__MODULE__{
          private_key: String.t(),
          client_email: String.t()
        }

  defstruct [
    :private_key,
    :client_email
  ]

  @doc """
  Initialize GcsSigner.Client from given keyfile.

  ## Examples

      iex> service_account = service_account_json_str |> Poison.decode!
      iex> GcsSigner.Client.from_keyfile(service_account)
      %GcsSigner.Client{...}

  """
  @spec from_keyfile(map()) :: __MODULE__.t()
  def from_keyfile(%{
        "private_key" => private_key,
        "client_email" => client_email
      }) do
    %GcsSigner.Client{
      private_key: private_key,
      client_email: client_email
    }
  end
end
