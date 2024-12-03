{:ok, contents} = File.read("input")

# ok stop yelling, ik this is a disaster
regex = ~r/(do\(\)|don\'t\(\)|mul\((\d{1,3}),(\d{1,3})\))/

Regex.scan(regex, contents)
|> Enum.reduce({true, []}, fn
  # disable processing
  ["don't()" | _], {_, acc} ->
    {false, acc}

  # enable Processing
  ["do()" | _], {_, acc} ->
    {true, acc}

  # process mul if enabled
  ["mul(" <> _, _full, num1, num2], {true, acc} ->
    {true, acc ++ [[String.to_integer(num1), String.to_integer(num2)]]}

  # ignore mul if disabled
  ["mul(" <> _, _full, _num1, _num2], {false, acc} ->
    {false, acc}
end)
|> elem(1)
|> Enum.map(fn [d1, d2] -> d1 * d2 end)
|> Enum.sum()
|> IO.inspect()
