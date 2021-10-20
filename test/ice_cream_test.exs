defmodule IceCreamTest do
  use ExUnit.Case

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
    assert ExUnit.CaptureIO.capture_io(fn ->
             ExamplePipeline.some_fun(42)
           end) == """
           ic| data: 42
           ic| fabricate(data): 42
           ic| cleanup(fabricate(data)): 42
           """
  end
end
