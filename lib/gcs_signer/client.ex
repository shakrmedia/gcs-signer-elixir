defmodule GcsSigner.Client do
  @moduledoc """
  Holds Google Cloud Service Account JSON
  """

  defstruct private_key: nil, client_email: nil

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
