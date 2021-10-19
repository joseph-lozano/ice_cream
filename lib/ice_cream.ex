defmodule IceCream do
  @spec ic() :: :ok
  @doc """
  Prints the calling filename, line number, and parent module/function. It returns an `:ok` atom.

  ```elixir
  # lib/foo.ex
  defmodule Foo do
    use IceCream

    def bar do
      ic()
    end
  end

  # running Foo.bar()
  Foo.bar() # ic| lib/foo.ex:5 in Elixir.Foo.bar/0
  :ok
  ```
  """

  defmacro ic() do
    quote do
      %{file: file, line: line, module: module, function: function} = __ENV__
      file = Path.relative_to_cwd(file)

      if is_nil(function) do
        IO.puts("ic| #{file}:#{line}")
      else
        {func, arity} = function
        IO.puts("ic| #{file}:#{line} in #{module}.#{func}/#{arity}")
      end
    end
  end

  @spec ic(term(), keyword()) :: term()
  @doc """
  Prints the term with itself as a label. Returns the evaluated term.

  ## Examples

  #### Variables

  ```
  foo = "abc"
  ic(foo) # ic| foo: "abc"
  "abc"
  ```

  #### Module Function Argument calls
  ```
  ic(:math.pow(2,3)) # ic| :math.pow(2,3): 8.0
  8.0
  ```
  It also works with pipes
  ```
  2
  |> :math.pow(3)
  |> ic() # ic| :math.pow(2,3): 8.0`
  8.0
  ```

  ## Options

  Accepts the same options as the Inspect protocol. (see: [`Inspect.Opts`](https://hexdocs.pm/elixir/Inspect.Opts.html)), with some additions:

  * `:location` - when truthy, will add the file name and line number.
  * `:function` - when truthy, will print out the module name with the function name and arity.

  ```
  # lib/foo.ex
  defmodule Foo do
    use IceCream

    def bar(baz) do
      ic(baz, location: true, function: true)
    end
  end

  # running Foo.bar()
  Foo.bar(1.0) # ic| lib/foo.ex:5 in Elixir.Foo.bar/1 baz: 1.0
  1.0
  ```
  """

  defmacro ic(term, opts \\ []) do
    label = [Macro.to_string(term)]

    quote do
      opts = Keyword.merge(Application.get_all_env(:ice_cream), unquote(opts))
      label = unquote(label)

      label =
        if !!Keyword.get(opts, :function) and not is_nil(__ENV__.function) do
          %{module: module, function: function} = __ENV__
          {func, arity} = function
          ["in #{module}.#{func}/#{arity} " | label]
        else
          label
        end

      label =
        if Keyword.get(opts, :location) do
          %{file: file, line: line} = __ENV__
          file = Path.relative_to_cwd(file)
          ["#{file}:#{line} " | label]
        else
          label
        end

      label = ["ic| " | label]
      opts = Keyword.merge([label: label], opts)

      IO.inspect(unquote(term), opts)
    end
  end

  defmacro __using__(_opts) do
    quote do
      require IceCream
      import IceCream
    end
  end
end
