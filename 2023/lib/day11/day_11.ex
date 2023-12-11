defmodule AoC2023.Day11 do
  def parse_input(input, expand \\ 2) do
    lines =
      input
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(fn line -> String.codepoints(line) end)

    width = Enum.at(lines, 0) |> Enum.count()

    expand_row_indexes =
      lines
      |> Enum.with_index()
      |> Enum.flat_map(fn {line, i} ->
        if Enum.any?(line, &(&1 == "#")) do
          []
        else
          [i]
        end
      end)

    expand_col_indexes =
      0..(width - 1)
      |> Enum.flat_map(fn i ->
        if Enum.any?(lines, fn line ->
             Enum.at(line, i) == "#"
           end) do
          []
        else
          [i]
        end
      end)

    lines
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, row} ->
      line
      |> Enum.with_index()
      |> Enum.map(fn {char, col} ->
        {{row, col}, char}
      end)
      |> Enum.filter(fn {_, char} -> char == "#" end)
    end)
    |> e_x_p_a_n_d(expand_row_indexes, expand_col_indexes, expand)
  end

  def e_x_p_a_n_d(stars, expand_row_indexes, expand_col_indexes, expand) do
    stars
    |> Enum.map(fn {{row, col}, value} ->
      new_row = Enum.count(expand_row_indexes, &(&1 < row)) * (expand - 1) + row
      new_col = Enum.count(expand_col_indexes, &(&1 < col)) * (expand - 1) + col

      {{new_row, new_col}, value}
    end)
  end

  @doc """
    iex> part1(AoC2023.Day11.Input.test_input())
    374

    iex> part1(AoC2023.Day11.Input.input())
    9608724

  """
  def part1(input) do
    parse_input(input) |> distances([]) |> Enum.sum()
  end

  def distances([], distances_acc), do: distances_acc

  def distances([{{hd_star_row, hd_star_col}, _} | stars], distances_acc) do
    new_distances =
      Enum.map(stars, fn {{row, col}, _} ->
        abs(hd_star_row - row) + abs(hd_star_col - col)
      end)

    distances(stars, new_distances ++ distances_acc)
  end

  @doc """
    iex> part2(AoC2023.Day11.Input.test_input(), 10)
    1030

    iex> part2(AoC2023.Day11.Input.test_input(), 100)
    8410

    iex> part2(AoC2023.Day11.Input.input())
    904633799472

  """
  def part2(input, expand \\ 1_000_000) do
    parse_input(input, expand) |> distances([]) |> Enum.sum()
  end
end
