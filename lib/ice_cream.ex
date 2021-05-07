defmodule IceCream do
  defmacro ic(term) do
    label = IO.inspect(Macro.to_string(term))

    quote do
      IO.inspect(unquote(term), label: "ic|" <> unquote(label))
    end
  end

  defmacro ic() do
    quote do
      %{file: file, line: line, module: module, function: function} = __ENV__
      file = Path.relative_to_cwd(file)

      if is_nil(function) do
        IO.puts("ic|#{file}:#{line}")
      else
        IO.puts("ic|#{module}.#{function} in #{file}:#{line}")
      end
    end
  end

  defmacro __using__(_opts) do
    quote do
      require IceCream
      import IceCream, only: [ic: 0, ic: 1]
    end
  end
end
