{:ok, contents} = File.read("input")

grid =
  contents
  |> String.trim()
  |> String.split("\n")
  |> Enum.map(&String.to_charlist/1)

defmodule XMasSearch do
  def count_xmas(grid) do
    max_x = length(grid)
    max_y = length(hd(grid))

    # scan every cell that can be the center of the 'X'
    # that means x must be between 1 and max_x-2, and y must be between 1 and max_y-2
    # because we need at least one row above, one row below, one column to the left, and one column to the right
    Enum.reduce(1..(max_x - 2), 0, fn x, acc ->
      Enum.reduce(1..(max_y - 2), acc, fn y, acc_inner ->
        acc_inner + check_center(grid, x, y)
      end)
    end)
  end

  defp check_center(grid, x, y) do
    center_char = char_at(grid, x, y)
    # center must be 'A'
    if center_char == ?A do
      diag1 = [char_at(grid, x - 1, y - 1), char_at(grid, x, y), char_at(grid, x + 1, y + 1)]
      diag2 = [char_at(grid, x - 1, y + 1), char_at(grid, x, y), char_at(grid, x + 1, y - 1)]

      valid_diag1 = valid_mas_pattern?(diag1)
      valid_diag2 = valid_mas_pattern?(diag2)

      if valid_diag1 and valid_diag2 do
        1
      else
        0
      end
    else
      0
    end
  end

  defp valid_mas_pattern?(pattern) do
    pattern in [
      ~c"MAS",
      ~c"SAM"
    ]
  end

  defp char_at(grid, x, y) do
    row = Enum.at(grid, x)
    Enum.at(row, y)
  end
end

XMasSearch.count_xmas(grid)
|> IO.inspect()

