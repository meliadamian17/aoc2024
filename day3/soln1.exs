{:ok, contents} = File.read("input")

Regex.scan(~r/do\(\)?mul\((\d{1,3}),(\d{1,3})\)don\'t\(\)/, contents)
|> Enum.map(fn [_full_match, d1, d2] -> String.to_integer(d1) * String.to_integer(d2) end)
|> Enum.sum()
|> IO.inspect()
