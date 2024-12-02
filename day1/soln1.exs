{:ok, contents} = File.read("input")

new =
  contents
  |> String.trim()
  |> String.split("\n")

lists =
  new
  |> Enum.map(&String.split(&1, ~r/\s+/))
  |> Enum.reduce([[], []], fn [a, b], [left, right] ->
    [[String.to_integer(a) | left], [String.to_integer(b) | right]]
  end)
  |> Enum.map(&Enum.sort(&1))

[left, right] = lists

Enum.zip(left, right)
|> Enum.map(fn {a, b} -> abs(a - b) end)
|> Enum.sum()
|> IO.inspect()
