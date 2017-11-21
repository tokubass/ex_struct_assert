defmodule StructAssert do
  @moduledoc """
  A useful tool for testing sturct and map in Elixir.
  """

  @doc """
  assert only a part of struct and map.

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
      end

      # code:  assert_subset?(got, %{a: 1, b: 2})
      # left:  %{a: 1, z: 10, b: 1}
      # right: %{a: 1, z: 10, b: 2}

  """

  defmacro assert_subset?({got_var_name,_,_} = got, {expect_var_name,_,_} = expect ) do
    quote do
      import  ExUnit.Assertions
      got_map = case unquote(got) do
                  %_{} -> Map.from_struct(unquote(got))
                  %{}  -> unquote(got)
                  _    -> :error
                end

      got_var = case unquote(got_var_name) do
                  :%   -> inspect(unquote(got))
                  :%{} -> inspect(unquote(got))
                  _    -> unquote(got_var_name)
                end

      
      expect = Map.merge(got_map, unquote(expect));

      expect_var = case unquote(expect_var_name) do
                     :%   -> inspect(unquote(expect))
                     :%{} -> inspect(unquote(expect))
                     _    -> unquote(expect_var_name)
                   end

      assert got_map == expect,
        expr: "assert_subset?(#{got_var}, #{expect_var})",
        left: got_map,
        right: expect
    end
  end

end
