require IceCream
import IceCream

# int = 123
# ic(123)
# ic(int)
# float = 99.23
# ic(99.23)
# ic(float)
# string = "456"
# ic("456")
# ic(string)
# map = %{foo: :bar}
# ic(%{foo: :bar})
# ic(map)
# list = [1, 2, 3]
# ic([1, 2, 3])
# ic(list)
# range = 1..3
# ic(1..3)
# ic(range)

defmodule Math do
  def add(a, b), do: a + b
end

ic(Math.add(1, 2))
ic(Atom.to_string(:foo))
ic(:math.pi())
ic(:math.pi())
ic(:math.pow(2, 3))

"1"
|> String.to_integer()
|> :math.sin()
|> ic()
|> ic()

list = 1..100 |> Enum.to_list()
ic(list)
