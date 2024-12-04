defmodule AoC2024.Day04 do
  @moduledoc """
  Quick and easy. I love word searches. 4 years of AoC grids made boilerplate so easy
  """

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, row_index} ->
      row
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.map(fn {character, col_index} ->
        {{row_index, col_index}, character}
      end)
    end)
    |> Map.new()
  end

  @doc """
    iex> part1(AoC2024.Day04.Input.test_input())
    18

    iex> part1(AoC2024.Day04.Input.input())
    2447

  """
  def part1(input) do
    grid = parse_input(input)

    Enum.map(grid, fn {coord, _} ->
      count_from_coord(grid, coord)
    end)
    |> Enum.sum()
  end

  defp count_from_coord(grid, coord) do
    get_all_coord_sequences(coord)
    |> Enum.map(fn sequence ->
      Enum.map(sequence, fn coord ->
        Map.get(grid, coord, "")
      end)
      |> Enum.join()
    end)
    |> Enum.count(fn word -> word == "XMAS" end)
  end

  defp get_all_coord_sequences({origin_row, origin_col} = coord) do
    [{-1, -1}, {-1, 0}, {-1, 1}, {0, -1}, {0, 1}, {1, -1}, {1, 0}, {1, 1}]
    |> Enum.map(fn {row, col} ->
      Enum.reduce(1..3, [coord], fn i, acc ->
        [{origin_row + row * i, origin_col + col * i} | acc]
      end)
      |> Enum.reverse()
    end)
  end

  @doc """
    iex> part2(AoC2024.Day04.Input.test_input())
    9

    iex> part2(AoC2024.Day04.Input.input())
    1868

  """
  def part2(input) do
    grid = parse_input(input)

    Enum.map(grid, fn {coord, _} ->
      count_from_coord_2(grid, coord)
    end)
    |> Enum.count(& &1)
  end

  defp count_from_coord_2(grid, coord) do
    get_all_coord_sequences_2(coord)
    |> Enum.map(fn sequence ->
      Enum.map(sequence, fn coord ->
        Map.get(grid, coord, "")
      end)
      |> Enum.join()
    end)
    |> Enum.all?(fn word -> word == "MAS" || word == "SAM" end)
  end

  defp get_all_coord_sequences_2({origin_row, origin_col}) do
    [
      [
        {origin_row - 1, origin_col - 1},
        {origin_row, origin_col},
        {origin_row + 1, origin_col + 1}
      ],
      [
        {origin_row + 1, origin_col - 1},
        {origin_row, origin_col},
        {origin_row - 1, origin_col + 1}
      ]
    ]
  end
end
