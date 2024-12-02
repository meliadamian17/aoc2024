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

[left, right] = lists

counts = Enum.frequencies(right)

Enum.reduce(left, 0, fn x, acc -> acc + x * Map.get(counts, x, 0) end)
|> IO.inspect()

# IO.inspect(left)
# IO.inspect(right)
