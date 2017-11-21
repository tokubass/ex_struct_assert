# StructAssert


## Examples

```elixir
  
  defmodule MyStruct do
    defstruct a: 1, b: 1, z: 10
  end

  defmodule Example
    use ExUnit.Case
    import StructAssert, only: [assert_subset?: 2]

    got  = %MyStruct{}
    assert_subset?(
      got,
      %{
        a: 1,
        b: 2
      }
    )

    # code:  assert_subset?(got, %{a: 1, b: 2})
    # left:  %{a: 1, z: 10, b: 1}
    # right: %{a: 1, z: 10, b: 2}
  end
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `struct_assert` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:struct_assert, "~> 0.1.0"}]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/struct_assert](https://hexdocs.pm/struct_assert).

