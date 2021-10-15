# IceCream

This is a port of the [IceCream python package](https://github.com/gruns/icecream)

## Installation

The package can be installed by adding `ice_cream` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ice_cream, "~> 0.0.1"}
  ]
end
```

The docs can be found at [https://hexdocs.pm/ice_cream](https://hexdocs.pm/ice_cream).

## Usage

Use IceCream in place of `IO.inspect/2`. So write `ic(value)` instead of
`IO.inspect(some_value, label: "some_value")`

It can also be used inside of pipelines. You can write:

``` elixir
import IceCream

def some_fun(data) do
  data
  |> ic()
  |> fabricate()
  |> ic()
  |> cleanup()
  |> ic()
end

# prints
ic| data: <data>
ic| fabricate(ic(data)): <data>
ic| cleanup(ic(fabricate(ic(data)))): <data>
```

Instead of:

``` elixir
def some_fun(data) do
  data
  |> IO.inspect(label: "data")
  |> fabricate()
  |> IO.inspect(label: "fabricate")
  |> cleanup()
  |> IO.inspect(label: "cleanup")
end

# prints
data: <data>
fabricate: <data>
cleanup: <data>
```
