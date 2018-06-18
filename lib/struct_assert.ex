defmodule StructAssert do
  @moduledoc """
  A useful tool for testing sturct and map in Elixir.
  """
  use Exporter, default: [assert_subset: 2]

  @doc """
  assert only a part of struct and map.

      defmodule MyStruct do
        defstruct a: 1, b: 1, z: 10
      end

      defmodule Example
        use ExUnit.Case
        use StructAssert

        test "example" do
          assert_subset(%MyStruct{}, [a: 1, b: 2])
          # code:  assert_subset(%MyStruct{}, [a: 1, b: 2])
          # left:  %{a: 1, b: 1, z: 10}
          # right: %{a: 1, b: 2, z: 10}

          assert_subset(%MyStruct{}, [a: 1, b: &is_atom(&1)])
          # code:  assert_subset(%MyStruct{}, [a: 1, b: &(is_atom(&1))])
          # left:  %{a: 1, z: 10, b: 1}
          # right: %{a: 1, z: 10, b: &:erlang.is_atom/1}
        end
      end

  """

  defmacro assert_subset(got, expect) do
    expr = build_expr_for_error_message(got, expect)
    got_map = got_value_to_map(got)
    expect_map = expect_value_to_map(expect)

    quote do
      got_map = unquote(got_map)
      expect_map = unquote(expect_map)

      expect =
        DeepMerge.deep_merge(got_map, expect_map, fn
          _, original, override when is_function(original) and is_function(override) ->
            DeepMerge.continue_deep_merge()

          _, original, override when is_function(override) ->
            case override.(original) do
              true -> original
              _ -> override
            end

          _, _original, _override ->
            DeepMerge.continue_deep_merge()
        end)

      assert got_map == expect,
        expr: unquote(expr),
        left: got_map,
        right: expect
    end
  end

  defp build_expr_for_error_message(got, expect) do
    got_var_name = got |> Macro.expand(__ENV__) |> Macro.to_string()
    expect_var_name = expect |> Macro.expand(__ENV__) |> Macro.to_string()
    "assert_subset(#{got_var_name}, #{expect_var_name})"
  end

  defp got_value_to_map(got) do
    quote do
      got = unquote(got)

      case got do
        %_{} -> Map.from_struct(got)
        %{} -> got
      end
    end
  end

  defp expect_value_to_map(expect) do
    quote do
      expect = unquote(expect)

      case expect do
        %{} -> expect
        is_list -> Enum.into(expect, %{})
      end
    end
  end
end
