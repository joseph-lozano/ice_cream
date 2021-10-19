# IceCream

IceCream is a port of the [python package](https://github.com/gruns/icecream) of the same name.

## Installation

The package can be installed by adding `ice_cream` to your list of dependencies in `mix.exs` . It should only be added for the `dev` and `test` environments.

```elixir
def deps do
  [
    {:ice_cream, "~> 0.0.3", only: [:dev, :test]}
  ]
end
```

The docs can be found at [https://hexdocs.pm/ice_cream](https://hexdocs.pm/ice_cream).

## Usage

IceCream provides 2 macros. `IceCream.ic/0` , and `IceCream.ic/2` .

## Configuration

Default options can be configured with Mix.

In addition to `location` and `function` , any of the [Inspect options](https://hexdocs.pm/elixir/Inspect.Opts.html) can be set, such as `:limit`

```elixir
# config/dev.exs
config :ice_cream,
  location: true,
  function: true,
  limit: :infinity
```
