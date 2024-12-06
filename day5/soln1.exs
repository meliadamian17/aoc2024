{:ok, contents} = File.read("input")

defmodule Validator do
  def validate_update(update, rules) do
    positions =
      Enum.with_index(update)
      |> Map.new()

    Enum.all?(rules, fn rule ->
      [x, y] = String.split(rule, "|") |> Enum.map(&String.to_integer/1)

      cond do
        Map.has_key?(positions, x) and Map.has_key?(positions, y) ->
          positions[x] < positions[y]

        true ->
          true
      end
    end)
  end

  def find_middle_sum(valid_updates) do
    valid_updates
    |> Enum.map(&find_middle/1)
    |> Enum.sum()
  end

  defp find_middle(update) do
    middle = div(length(update), 2)
    Enum.at(update, middle)
  end
end

defmodule InputParser do
  def parse(input) do
    [rules_section, updates_section] = String.split(input, "\n\n", parts: 2)

    rules = String.split(rules_section, "\n", trim: true)

    updates =
      updates_section
      |> String.split("\n", trim: true)
      |> Enum.map(fn update ->
        update
        |> String.split(",")
        |> Enum.map(&String.to_integer/1)
      end)

    {rules, updates}
  end
end

{rules, updates} = InputParser.parse(contents)

valid_updates =
  updates
  |> Enum.filter(fn update -> Validator.validate_update(update, rules) end)

result =
  Validator.find_middle_sum(valid_updates)
  |> IO.inspect()

