defmodule IceCream do
  defmacro __using__(_opts) do
    quote do
      require IceCream
      import IceCream
    end
  end

  @doc """
  Prints the calling filename, line number, and parent module/function. It returns an `:ok` atom.

  ```elixir
  # lib/foo.ex
  defmodule Foo do
    import IceCream

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
      IceCream.build_label("", __ENV__, function: true, location: true)
      |> IO.puts()
    end
  end

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
    import IceCream

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
    label_io_list = [Macro.to_string(replace_ic(term))]

    quote do
      label = IceCream.build_label(unquote(label_io_list), __ENV__, unquote(opts))
      inspect_opts = Keyword.merge([label: label], unquote(opts))

      IO.inspect(unquote(term), inspect_opts)
    end
  end

  @doc false
  def build_label(term_string, env, opts) do
    opts = Keyword.merge(Application.get_all_env(:ice_cream), opts)

    [term_string]
    |> maybe_prepend_function(Keyword.get(opts, :function, false), env)
    |> maybe_prepend_location(Keyword.get(opts, :location, false), env)
    |> prepend_ic()
  end

  defp replace_ic({:ic, _meta, args}), do: replace_ic(List.first(args))
  defp replace_ic({f, m, args}) when is_list(args), do: {f, m, Enum.map(args, &replace_ic(&1))}
  defp replace_ic(ast), do: ast

  defp maybe_prepend_function(label_io_list, prepend?, env)
  defp maybe_prepend_function(label_io_list, false, _), do: label_io_list
  defp maybe_prepend_function(label_io_list, true, %{function: nil}), do: label_io_list

  defp maybe_prepend_function(label_io_list, true, env) do
    %{function: {func, arity}, module: module} = env

    [
      "in ",
      String.replace_leading(to_string(module), "Elixir.", ""),
      ".",
      to_string(func),
      "/",
      to_string(arity),
      " " | label_io_list
    ]
  end

  defp maybe_prepend_location(label_io_list, prepend?, env)
  defp maybe_prepend_location(label_io_list, false, _), do: label_io_list

  defp maybe_prepend_location(label_io_list, true, env) do
    %{file: file, line: line} = env
    file = Path.relative_to_cwd(file)
    [file, ":", to_string(line), " " | label_io_list]
  end

  defp prepend_ic(label_io_list), do: ["ic| " | label_io_list]
end
