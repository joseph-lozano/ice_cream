defmodule IceCreamTest do
  use ExUnit.Case
  use IceCream

  import ExUnit.CaptureIO

  @cases %{
    integer: 1234,
    float: 103.23,
    map: Macro.escape(%{foo: :bar}),
    list: [1, 2, 3],
    range: Macro.escape(1..3),
    string: "Hello World",
    binary: <<213, 25, 231>>
    # commented out until I can figure out how to make the warning disappear
    # pid: :c.pid(0, 220, 0)
  }

  describe "labeled" do
    Enum.each(@cases, fn {type, val} ->
      test "#{type}" do
        foo = unquote(val)

        assert io_out =
                 capture_io(:stdio, fn ->
                   assert ic(foo) == foo
                 end)

        assert io_out == "ic|foo: #{inspect(foo)}\n"
      end
    end)
  end

  describe "unlabeled" do
    Enum.each(@cases, fn {type, val} ->
      test "#{type}" do
        assert io_out =
                 capture_io(:stdio, fn ->
                   assert ic(unquote(val)) == unquote(val)
                 end)

        assert io_out == "ic|: #{inspect(unquote(val))}\n"
      end
    end)
  end
end
