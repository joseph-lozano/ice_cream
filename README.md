# IceCream

IceCream is a port of the [python package](https://github.com/gruns/icecream) of the same name.

#### Never use `IO.inspect()` again

Use IceCream to inspect any Elixir term with an automatically generated label.

![Example Usage](./screen-shot.png)

## Installation

The package can be installed by adding `ice_cream` to your list of dependencies in `mix.exs` . It should only be added for the `dev` and `test` environments.

```elixir
def deps do
  [
    {:ice_cream, "~> 0.0.5", only: [:dev, :test]}
  ]
end
```

The docs can be found at [https://hexdocs.pm/ice_cream](https://hexdocs.pm/ice_cream).

## Usage

IceCream provides 2 macros. `IceCream.ic/0` , and `IceCream.ic/2` .

## Configuration

Default options are configurable.

In addition to `location` and `function` , any of the [Inspect options](https://hexdocs.pm/elixir/Inspect.Opts.html) can be set, such as `:limit`

```elixir
# config/dev.exs
config :ice_cream,
  location: true,
  function: true,
  limit: :infinity
```
