defmodule IceCreamTest do
  use ExUnit.Case
  use IceCream

  import ExUnit.CaptureIO

  test "IceCream" do
    foo = 1234

    assert io_out =
             capture_io(:stdio, fn ->
               assert ic(foo) == foo
             end)

    assert io_out == "ic|foo: #{foo}\n"
  end
end
