# gcs-signer-elixir

Simple signed URL generator for Google Cloud Storage, written in Elixir.

## Features

* Zero dependencies.
* No network connection required to generate signed URL.

## Installation

This package can be installed
by adding `gcs_signer` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:gcs_signer, "~> 0.1.0"}
  ]
end
```

## Usage

```elixir
json = Poison.decode! service_account_keyfile_json_string
client = GcsSigner.Client.from_keyfile(json)

GcsSigner.sign_url(client, "my-bucket", "my-object")
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/gcs_signer](https://hexdocs.pm/gcs_signer).

