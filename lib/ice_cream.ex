defmodule IceCream do
  @spec ic() :: Macro.t()
  @doc """
  Prints the calling filename, line number, and parent module/function.
  """

  defmacro ic() do
    quote do
      IceCream.build_label("", __ENV__, function: true, location: true)
      |> IO.puts()
    end
  end

  @spec ic(term(), Keyword.t()) :: Macro.t()
  @doc """
  Prints the term with itself as a label. Returns the evaluated term.

  Accepts the same `opts` as the Inspect protocol. (see: [`Inspect.Opts`](https://hexdocs.pm/elixir/Inspect.Opts.html))

  ## Examples
  ### Variables
      foo = "abc"
      ic(foo)
  Prints
      ic| foo: "abc"

  ### Module Function Argument calls
      ic(:math.pow(2,3))
  Prints
      ic| :math.pow(2,3): 8.0

  It also works with pipes
      2
      |> :math.pow(3)
      |> ic()

  also prints `ic| :math.pow(2,3): 8.0`
  """

  defmacro ic(term, opts \\ []) do
    label_io_list = [Macro.to_string(term)]

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

  defp maybe_prepend_function(label_io_list, prepend?, env)
  defp maybe_prepend_function(label_io_list, false, _), do: label_io_list
  defp maybe_prepend_function(label_io_list, true, %{function: nil}), do: label_io_list

  defp maybe_prepend_function(label_io_list, true, env) do
    %{function: {func, arity}, module: module} = env
    ["in ", to_string(module), ".", to_string(func), "/", to_string(arity), " " | label_io_list]
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
