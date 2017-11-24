defmodule CallbackTest do
  use ExUnit.Case
  import StructAssert, only: [assert_subset: 2]

  defmacrop catch_assertion(expr) do
    quote do
      try do
        unquote(expr)
      rescue
        ex -> ex
      end
    end
  end


  describe "callback" do
    test "normal" do
      assert_subset(
        %{"name" => "Name", "user_id" => 1 },
        %{
          "name" =>  fn x -> x =~ ~r/[A-Za-z]/ end,
          "user_id" => &is_integer(&1)
        }
      )

      res = catch_assertion(
        assert_subset(
          %{"name" => "Name", "user_id" => "string" },
          %{
            "name" =>  fn x -> x =~ ~r/[A-Za-z]/ end,
            "user_id" => &is_integer(&1)
          }
        )
      )
      assert res.expr  == "assert_subset(%{\"name\" => \"Name\", \"user_id\" => \"string\"}, %{\"name\" => fn x -> x =~ ~r\"[A-Za-z]\" end, \"user_id\" => &(is_integer(&1))})"
      assert res.left  == %{"name" => "Name", "user_id" => "string"}
      assert res.right == %{"name" => "Name", "user_id" => &:erlang.is_integer/1}
    end

    test "compare function" do
      assert_subset(
        %{"name" => "Name", "user_id" => &is_integer(&1) },
        %{
          "name" =>  fn x -> x =~ ~r/[A-Za-z]/ end,
          "user_id" => &is_integer(&1)
        }
      )

      fn_is_integer = fn x -> is_integer x end
      res = catch_assertion(
        assert_subset(
          %{"name" => "Name", "user_id" => fn_is_integer },
          %{
            "name" =>  fn x -> x =~ ~r/[A-Za-z]/ end,
            "user_id" => &is_integer(&1)
          }
        )
      )

      assert res.expr  == "assert_subset(%{\"name\" => \"Name\", \"user_id\" => fn_is_integer}, %{\"name\" => fn x -> x =~ ~r\"[A-Za-z]\" end, \"user_id\" => &(is_integer(&1))})"
      assert res.left["name"]  == "Name"
      assert res.left["user_id"] == fn_is_integer
      assert res.right == %{"name" => "Name", "user_id" => &:erlang.is_integer/1}
    end
  end
end
