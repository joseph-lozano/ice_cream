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

ic(:math.pow(2, 3))

Application.put_env(:ice_cream, :location, true)
Process.sleep(400)
ic(:math.pi())

Application.put_env(:ice_cream, :line, true)
Process.sleep(400)

defmodule Foo do
  def bar(x) do
    ic(x)
  end
end

Foo.bar(1)

# 2
# |> :math.pow(3)
# |> ic()

# list = 1..100 |> Enum.to_list()
# ic(list)

# ic()
