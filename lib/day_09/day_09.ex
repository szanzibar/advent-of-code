defmodule AoC.Day09 do
  defp get_input(file) do
    lines = File.read!(Path.join(__DIR__, file)) |> String.split("\n", trim: true)

    height = Enum.count(lines) - 1
    width = String.length(Enum.at(lines, 0)) - 1

    grid =
      lines
      |> Enum.map(
        &(String.graphemes(&1)
          |> Enum.map(fn s -> String.to_integer(s) end)
          |> Enum.with_index())
      )
      |> Enum.with_index()
      |> Enum.flat_map(fn {row, x} ->
        Enum.map(row, fn {num, y} ->
          %{[x, y] => num}
        end)
      end)
      |> Enum.reduce(%{}, &Map.merge(&1, &2))

    {grid, height, width}
  end

  def part1(input) do
    get_input(input)
    |> get_lowest_points()
    |> Map.values()
    |> Enum.reduce(0, fn x, acc ->
      acc + 1 + x
    end)
  end

  defp get_lowest_points({grid, height, width}) do
    for x <- 0..height, y <- 0..width do
      lowest?(grid, [x, y])
    end
    |> Enum.filter(&(!is_nil(&1)))
    |> Enum.reduce(%{}, &Map.merge(&1, &2))
  end

  defp lowest?(grid, [x, y]) do
    current = grid[[x, y]]

    neighbors = [grid[[x, y + 1]], grid[[x + 1, y]], grid[[x, y - 1]], grid[[x - 1, y]]]

    case current < Enum.min(neighbors) do
      true -> %{[x, y] => current}
      false -> nil
    end
  end

  def part2(input) do
    input = get_input(input)

    {grid, _, _} = input

    lowest =
      input
      |> get_lowest_points()
      |> Map.keys()

    Enum.map(lowest, fn coord ->
      get_neighbor_basin([coord], grid, coord)
      |> Enum.count()
    end)
    |> Enum.sort()
    |> Enum.take(-3)
    |> Enum.reduce(1, &(&1 * &2))
  end

  defp get_neighbor_basin(current_basin, _grid, nil), do: current_basin

  defp get_neighbor_basin(current_basin, grid, [x, y]) do
    neighbors = Map.take(grid, [[x, y + 1], [x + 1, y], [x, y - 1], [x - 1, y]])

    next_keys =
      Map.filter(neighbors, fn {k, v} ->
        v < 9 && !Enum.member?(current_basin, k)
      end)
      |> Map.keys()

    case next_keys do
      [] ->
        current_basin

      _ ->
        Enum.concat(current_basin, next_keys)
        |> Enum.uniq()
        |> get_neighbor_basin(grid, Enum.at(next_keys, 0))
        |> get_neighbor_basin(grid, Enum.at(next_keys, 1))
        |> get_neighbor_basin(grid, Enum.at(next_keys, 2))
        |> get_neighbor_basin(grid, Enum.at(next_keys, 3))
    end
  end
end
