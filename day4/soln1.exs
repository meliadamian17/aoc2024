{:ok, contents} = File.read("test")

grid =
  contents
  |> String.trim()
  |> String.split("\n")
  |> Enum.map(&String.to_charlist(&1))

defmodule WordSearch do
  def count_occurances(grid, word) do
    directions = [
      {1, 0},
      {-1, 0},
      {0, 1},
      {0, -1},
      {1, 1},
      {-1, -1},
      {1, -1},
      {-1, 1}
    ]

    word_chars = String.to_charlist(word)

    grid
    |> Enum.with_index()
    |> Enum.reduce(0, fn {row, i}, acc ->
      row
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {_char, j}, acc_inner ->
        acc_inner +
          Enum.reduce(directions, 0, fn {dx, dy}, dir_acc ->
            dir_acc + count_word(grid, word_chars, i, j, dx, dy)
          end)
      end)
    end)
  end

  defp count_word(grid, word, x, y, dx, dy) do
    word_length = length(word)

    Enum.reduce_while(0..(word_length - 1), true, fn step, _ ->
      char_x = x + step * dx
      char_y = y + step * dy

      cond do
        char_x < 0 or char_x >= length(grid) ->
          {:halt, false}

        char_y < 0 or char_y >= length(grid) ->
          {:halt, false}

        Enum.at(Enum.at(grid, char_x), char_y) != Enum.at(word, step) ->
          {:halt, false}

        true ->
          {:cont, true}
      end
    end)
    |> case do
      true -> 1
      _ -> 0
    end
  end
end

word = "XMAS"

WordSearch.count_occurances(grid, word)
|> IO.inspect()
