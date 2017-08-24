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
    {:gcs_signer, "~> 0.1.1"}
  ]
end
```

## Usage

```elixir
json = Poison.decode! service_account_keyfile_json_string
client = GcsSigner.Client.from_keyfile(json)

GcsSigner.sign_url(client, "my-bucket", "my-object")
```

## Links

* [Ruby version of gcs-signer](https://github.com/shakrmedia/gcs-signer)
* [HexDocs](https://hexdocs.pm/gcs_signer)

## License

gcs-signer-elixir is distributed under the MIT License.
