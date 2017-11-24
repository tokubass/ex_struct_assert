defmodule ComplexTest do
  use ExUnit.Case
  use StructAssert

  test "map" do
    got = %{
      "data" => %{ :currentCity => "pune",
                  "mobileNumber" => "1234567890",
                  "name" => "xyz",
                  "gender" => "male"}
    }

   assert_subset(got,   %{ "data" => %{ :currentCity => "pune", "mobileNumber" => "1234567890"}}  )
   assert_subset(got["data"],   %{ :currentCity => "pune", "mobileNumber" => "1234567890"} )
  end

  test "map2" do
    got = %{
      [:data, :data2] => %{"currentCity" => "pune", %{ a: 1} => 1 },
      %{ a: 2 } => %{ b: 2 }
    }
    res = try do
            assert_subset(got,   %{ [:data, :data2] => %{"currentCity" => "pune", %{ a: 1 } => [1,2,3] }})
          rescue
              error in [ExUnit.AssertionError] -> error
          end

    assert res.expr  == "assert_subset(got, %{[:data, :data2] => %{\"currentCity\" => \"pune\", %{a: 1} => [1, 2, 3]}})"
    assert res.left  == %{%{a: 2} => %{b: 2}, [:data, :data2] => %{"currentCity" => "pune", %{a: 1} => 1}}
    assert res.right == %{%{a: 2} => %{b: 2}, [:data, :data2] => %{"currentCity" => "pune", %{a: 1} => [1, 2, 3]}}
  end


end
