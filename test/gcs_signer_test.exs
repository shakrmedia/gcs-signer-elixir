defmodule GcsSignerTest do
  use ExUnit.Case
  doctest GcsSigner

  test "greets the world" do
    assert GcsSigner.hello() == :world
  end
end
