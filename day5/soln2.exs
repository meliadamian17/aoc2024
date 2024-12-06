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

  def correct_update(update, rules) do
    # build dependencies for pages present in the update
    dependencies =
      Enum.reduce(rules, %{}, fn rule, acc ->
        [x, y] = String.split(rule, "|") |> Enum.map(&String.to_integer/1)

        if x in update and y in update do
          Map.update(acc, x, [y], &[y | &1])
        else
          acc
        end
      end)

    sorted = topological_sort(dependencies)

    Enum.filter(sorted, &(&1 in update))
  end

  defp topological_sort(dependencies) do
    {sorted, _} =
      Enum.reduce(dependencies, {[], Map.new(dependencies, fn {k, _} -> {k, :unvisited} end)}, fn
        {node, _}, {acc, visited} ->
          if Map.get(visited, node) == :unvisited do
            dfs(dependencies, node, visited, [], acc)
          else
            {acc, visited}
          end
      end)

    sorted
  end

  defp dfs(dependencies, node, visited, on_stack, acc) do
    visited = Map.put(visited, node, :visiting)
    on_stack = MapSet.put(MapSet.new(on_stack), node)

    {acc, visited} =
      Enum.reduce(dependencies[node] || [], {acc, visited}, fn neighbor, {acc, visited} ->
        case Map.get(visited, neighbor) do
          :unvisited ->
            dfs(dependencies, neighbor, visited, on_stack, acc)

          _ ->
            {acc, visited}
        end
      end)

    visited = Map.put(visited, node, :visited)
    {[node | acc], visited}
  end

  def find_middle_sum(updates) do
    updates
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

{valid_updates, invalid_updates} =
  Enum.split_with(updates, fn update -> Validator.validate_update(update, rules) end)

corrected_updates =
  invalid_updates
  |> Enum.map(&Validator.correct_update(&1, rules))

result =
  Validator.find_middle_sum(corrected_updates)
  |> IO.inspect()
