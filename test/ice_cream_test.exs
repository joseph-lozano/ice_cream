defmodule IceCreamTest do
  use ExUnit.Case
  use IceCream

  defmodule ExamplePipeline do
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
           ic| fabricate(ic(data)): 42
           ic| cleanup(ic(fabricate(ic(data)))): 42
           """
             # ExamplePipeline.some_fun(42)
  end

  test "" do
    ExamplePipeline.some_fun(42)
  end
end
