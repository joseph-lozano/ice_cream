defmodule IceCreamTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  import IceCream

  defmodule ExamplePipeline do
    import IceCream

    def some_fun(data) do
      data
      |> ic()
      |> fabricate()
      |> ic()
      |> cleanup()
      |> ic()
    end

    defp fabricate(data), do: data
    defp cleanup(data), do: data
  end

  test "pipeline_example" do
    assert capture_io(fn ->
             ExamplePipeline.some_fun(42)
           end) ==
             """
             ic| data: 42
             ic| fabricate(data): 42
             ic| cleanup(fabricate(data)): 42
             """
  end

  describe "literals" do
    test "atoms" do
      assert capture_io(fn -> ic(:atom) end) ==
               "ic| :atom: :atom\n"
    end

    test "empty list" do
      assert capture_io(fn -> ic([]) end) ==
               "ic| []: []\n"
    end

    test "proper list" do
      assert capture_io(fn -> ic([:foo, :bar]) end) ==
               "ic| [:foo, :bar]: [:foo, :bar]\n"
    end

    test "improper list" do
      assert capture_io(fn -> ic([:foo | :bar]) end) ==
               "ic| [:foo | :bar]: [:foo | :bar]\n"
    end

    test "empty tuple" do
      assert capture_io(fn -> ic({}) end) ==
               "ic| {}: {}\n"
    end

    test "1 tuple" do
      assert capture_io(fn -> ic({1}) end) ==
               "ic| {1}: {1}\n"
    end

    test "2 tuple" do
      assert capture_io(fn -> ic({:foo, :bar}) end) ==
               "ic| {:foo, :bar}: {:foo, :bar}\n"
    end

    test "3 tuple" do
      assert capture_io(fn -> ic({:foo, [], [:bar]}) end) ==
               "ic| {:foo, [], [:bar]}: {:foo, [], [:bar]}\n"
    end
  end

  test "quotes" do
    assert capture_io(fn ->
             ic(
               quote do
                 :math.pow(2, 3)
               end
             )
           end) == """
           ic| quote do
             :math.pow(2, 3)
           end: {{:., [], [:math, :pow]}, [], [2, 3]}
           """
  end
end
