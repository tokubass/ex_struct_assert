defmodule StructAssert do

  @moduledoc """
  A useful tool for testing sturct and map in Elixir.
  """

  defmacro __using__(_opts) do
    quote do
      import StructAssert, only: [assert_subset: 2]
    end
  end
  
  @doc """
  assert only a part of struct and map.

      defmodule MyStruct do
        defstruct a: 1, b: 1, z: 10
      end

      defmodule Example
        use ExUnit.Case
        import StructAssert, only: [assert_subset: 2]

        assert_subset(%MyStruct{}, [a: 1, b: 2])
        # code:  assert_subset(%MyStruct{}, [a: 1, b: 2])
        # left:  %{a: 1, b: 1, z: 10}
        # right: %{a: 1, b: 2, z: 10}
      end


  """

  defmacro assert_subset(got, expect) do
    expr = build_expr_for_error_message(got,expect)
    quote do
      import  ExUnit.Assertions
      got_map  = StructAssert.got_value_to_map(unquote(got))
      expect_map = StructAssert.expect_value_to_map(unquote(expect))

      resolver = fn
        (_, original, override) when is_function(original) and is_function(override) -> DeepMerge.continue_deep_merge
        (_, original, override) when is_function(override) ->
          case override.(original) do
                 true -> original
                 _ -> override
          end

        (_, _original, _override) -> DeepMerge.continue_deep_merge
      end

      expect = DeepMerge.deep_merge(got_map,expect_map, resolver)
      assert got_map == expect,
        expr: unquote(expr),
        left: got_map,
        right: expect
    end
  end



  @doc """
  deprecated
  """
  defmacro assert_subset?(got, expect) do
    quote do
      StructAssert.assert_subset(unquote(got),unquote(expect))
    end
  end


  def build_expr_for_error_message(got,expect) do
    got_var_name = got |> Macro.expand(__ENV__) |> Macro.to_string
    expect_var_name = expect |> Macro.expand(__ENV__) |> Macro.to_string
    "assert_subset(#{got_var_name}, #{expect_var_name})"
  end

  defmacro got_value_to_map(got) do
    quote do
      case unquote(got) do
        %_{} -> Map.from_struct(unquote(got))
        %{}  -> unquote(got)
      end
    end
  end

  defmacro expect_value_to_map(expect) do
    quote do
      case unquote(expect) do
        %{}  -> unquote(expect)
        is_list -> Enum.into(unquote(expect), %{})
      end
    end
  end

end
