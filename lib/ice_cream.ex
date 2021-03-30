defmodule IceCream do
  defguardp is_primitive(term)
            when is_atom(term) or is_binary(term) or is_number(term) or is_pid(term) or
                   is_list(term) or is_map(term)

  defmacro ic(term) do
    label =
      case term do
        {:%{}, _, _} -> nil
        {label, _, nil} -> label
        other when is_primitive(other) -> nil
        other -> raise "Did not expect #{inspect(other)}"
      end
      |> to_string()

    quote do
      IO.inspect(unquote(term), label: "ic|" <> unquote(label))
    end
  end

  defmacro __using__(_opts) do
    quote do
      require IceCream
      import IceCream, only: [ic: 1]
    end
  end
end
