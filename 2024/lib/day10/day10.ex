defmodule AoC2024.Day10 do
  @moduledoc """
  ez pz! One of those days where everything worked first try, no performance problems,
  and part2 was just removing Enum.uniq from get_trails.
  """

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, row_i} ->
      row
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.map(fn {height, col_i} ->
        {{row_i, col_i}, String.to_integer(height)}
      end)
    end)
    |> Map.new()
  end

  @doc """
    iex> part1(AoC2024.Day10.Input.test_input())
    36

    iex> part1(AoC2024.Day10.Input.input())
    698

  """
  def part1(input) do
    map = parse_input(input)

    Enum.filter(map, fn {_coord, height} -> height == 0 end)
    |> Enum.map(fn zero_coord ->
      get_trails(zero_coord, map)
    end)
    |> Enum.sum()
  end

  defp get_trails(zero_coord, map) do
    get_next_step(zero_coord, map) |> List.flatten() |> Enum.uniq() |> Enum.count()
  end

  defp get_next_step({coord, height}, map) do
    coord
    |> next_coords
    |> Enum.map(fn next_coord ->
      Map.get(map, next_coord)
      |> case do
        next_height when next_height == height + 1 and next_height == 9 ->
          [{next_coord, next_height}]

        next_height when next_height == height + 1 ->
          get_next_step({next_coord, next_height}, map)

        _ ->
          []
      end
    end)
  end

  defp next_coords({row, col}) do
    [{-1, 0}, {0, 1}, {1, 0}, {0, -1}]
    |> Enum.map(fn {row_offset, col_offset} ->
      {row_offset + row, col_offset + col}
    end)
  end

  @doc """
    iex> part2(AoC2024.Day10.Input.test_input())
    81

    iex> part2(AoC2024.Day10.Input.input())
    1436

  """
  def part2(input) do
    map = parse_input(input)

    Enum.filter(map, fn {_coord, value} -> value == 0 end)
    |> Enum.map(fn zero_coord ->
      get_trails2(zero_coord, map)
    end)
    |> Enum.sum()
  end

  defp get_trails2(zero_coord, map) do
    get_next_step(zero_coord, map) |> List.flatten() |> Enum.count()
  end
end
