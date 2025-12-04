defmodule AoC2025.Day04 do
  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, row} ->
      String.graphemes(line)
      |> Enum.with_index()
      |> Enum.map(fn {roll, col} ->
        {{row, col}, roll}
      end)
    end)
    |> Map.new()
  end

  @doc """
    iex> part1(AoC2025.Day04.Input.test_input())
    13

    iex> part1(AoC2025.Day04.Input.input())
    1416

  """
  def part1(input) do
    map = parse_input(input)
    rolls = Enum.filter(map, fn {_coord, item} -> item == "@" end) |> Map.new()

    Map.keys(rolls)
    |> Enum.map(fn coord ->
      get_all_neighbors(map, coord) |> Enum.count(fn neighbor -> neighbor == "@" end)
    end)
    |> Enum.filter(fn count -> count < 4 end)
    |> Enum.count()
  end

  defp get_all_neighbors(map, {row, col}) do
    for(
      r <- [row - 1, row, row + 1],
      c <- [col - 1, col, col + 1],
      do: {r, c}
    )
    |> Stream.reject(&(&1 == {row, col}))
    |> Stream.map(&Map.get(map, &1))
    |> Enum.reject(&is_nil/1)
  end

  @doc """
    iex> part2(AoC2025.Day04.Input.test_input())
    43

    iex> part2(AoC2025.Day04.Input.input())
    9086

  """
  def part2(input) do
    parse_input(input)
    |> Enum.filter(fn {_coord, item} -> item == "@" end)
    |> Map.new()
    |> remove_rolls()
  end

  defp remove_rolls(map, count_acc \\ 0, count_change \\ 0)
  defp remove_rolls(_map, count_acc, 0) when count_acc > 0, do: count_acc

  defp remove_rolls(rolls, count_acc, last_count) do
    {count_removed, new_map} =
      rolls
      |> Enum.split_with(fn {coord, _value} ->
        neighbor_count =
          get_all_neighbors(rolls, coord) |> Enum.count(fn neighbor -> neighbor == "@" end)

        neighbor_count < 4
      end)

    remove_rolls(Map.new(new_map), count_acc + last_count, Enum.count(count_removed))
  end
end
