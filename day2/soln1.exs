{:ok, contents} = File.read("input")

defmodule Checker do
  def valid?(list) do
    list
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.all?(fn [a, b] ->
      abs(a - b) in 1..3 and
        strictly_increasing_or_decreasing?(list)
    end)
  end

  def strictly_increasing?(list) do
    Enum.reduce_while(list, :start, fn
      x, :start -> {:cont, x}
      x, prev when x > prev -> {:cont, x}
      _, _ -> {:halt, false}
    end) != false
  end

  def strictly_decreasing?(list) do
    Enum.reduce_while(list, :start, fn
      x, :start -> {:cont, x}
      x, prev when x < prev -> {:cont, x}
      _, _ -> {:halt, false}
    end) != false
  end

  def strictly_increasing_or_decreasing?(list) do
    strictly_increasing?(list) or strictly_decreasing?(list)
  end
end

contents
|> String.trim()
|> String.split("\n")
|> Enum.map(fn x ->
  String.split(x)
  |> Enum.map(&String.to_integer(&1))
end)
|> Enum.reduce(0, fn l, acc ->
  if Checker.valid?(l) do
    acc + 1
  else
    acc
  end
end)
|> IO.inspect()
