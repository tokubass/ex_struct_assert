defmodule MyStruct do
  defstruct a: 1, b: 1, z: 10
end


defmodule StructAssertTest do
  use ExUnit.Case
  import StructAssert, only: [assert_subset: 2]
  doctest StructAssert

  describe "subset(struct,map)" do
    test "success" do
      got  = %MyStruct{}
      expect = %{a: 1, b: 1 }
      assert_subset(got,  expect)
    end

    test "fail" do
      got_xx  = %MyStruct{}
      expect_fail = %{a: 1, b: 2 }
      res = try do
              assert_subset(
                got_xx,
                expect_fail
              )
            rescue
              error in [ExUnit.AssertionError] -> error
            end
      assert res.expr  == "assert_subset(got_xx, expect_fail)"
      assert res.left  == %{a: 1, b: 1, z: 10 }
      assert res.right == %{a: 1, b: 2, z: 10 }
    end
  end

  describe "subset(struct,map_literal)" do
    test "success" do
      got  = %MyStruct{}
      assert_subset(got, %{a: 1, b: 1})
    end
    test "fail" do
      got  = %MyStruct{}
      res = try do
              assert_subset(
                got,
                %{
                  a: 1,
                  b: 2
                }
              )
            rescue
              error in [ExUnit.AssertionError] -> error
            end

      assert res.expr  == "assert_subset(got, %{a: 1, b: 2})"
      assert res.left  == %{a: 1, b: 1, z: 10 }
      assert res.right == %{a: 1, b: 2, z: 10 }
    end
  end

  describe "subset(struct_literal,map)" do
    test "success" do
      expect = %{a: 1, b: 1 };
      assert_subset(%MyStruct{},  expect)
    end

    test "fail" do
      expect_fail = %{a: 1, b: 2 }
      res = try do
              assert_subset(
                %MyStruct{},
                expect_fail
              )
            rescue
              error in [ExUnit.AssertionError] -> error
            end
      assert res.expr  == "assert_subset(%MyStruct{}, expect_fail)"
      assert res.left  == %{a: 1, b: 1, z: 10 }
      assert res.right == %{a: 1, b: 2, z: 10 }
    end
  end

  describe "subset(struct_literal,map_literal)" do
    test "success" do
      assert_subset(%MyStruct{}, %{a: 1, b: 1})
    end
    test "fail" do
      res = try do
              assert_subset(
                %MyStruct{a: 1},
                %{
                  a: 1,
                  b: 2
                }
              )
            rescue
              error in [ExUnit.AssertionError] -> error
            end

      assert res.expr  == "assert_subset(%MyStruct{a: 1}, %{a: 1, b: 2})"
      assert res.left  == %{a: 1, b: 1, z: 10 }
      assert res.right == %{a: 1, b: 2, z: 10 }
    end
  end

  
  describe "subset(map,map)" do
    test "success" do
      got    = %{a: 1, b: 1 };
      expect = %{a: 1, b: 1 };
      assert_subset(got,expect)
    end
    test "fail" do
      got    = %{a: 1, b: 1 };
      expect = %{a: 1, b: 2 };

      res = try do
              assert_subset(got,expect)
            rescue
              error in [ExUnit.AssertionError] -> error
            end

      assert res.expr  == "assert_subset(got, expect)"
      assert res.left  == %{a: 1, b: 1}
      assert res.right == %{a: 1, b: 2}
    end
  end

  describe "subset(struct,kwlist)" do
    test "success" do
      assert_subset(
        struct(MyStruct, a: 1,b: 2),
        a: 1, b: 2
      )
      assert_subset(
        struct(MyStruct, [a: 1, b: [1,2], z: :v]),
        [a: 1, b: [1,2]] ++ [z: :v ]
      )
    end
    test "fail" do

      res = try do
              assert_subset(
                struct(MyStruct, a: 1,b: 2),
                [a: 1, b: 3]
              )
            rescue
              error in [ExUnit.AssertionError] -> error
            end
      assert res.expr  == "assert_subset(struct(MyStruct, a: 1, b: 2), [a: 1, b: 3])"
      assert res.left  == %{a: 1, b: 2, z: 10}
      assert res.right == %{a: 1, b: 3, z: 10}
    end
  end
  
end
