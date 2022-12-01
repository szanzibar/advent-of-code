defmodule AoC.Day13 do
  def get_input(file) do
    [coords, folds] =
      File.read!(Path.join(__DIR__, file))
      |> String.split("\n\n", trim: true)
      |> Enum.map(&String.split(&1, "\n", trim: true))

    coords =
      Enum.map(coords, fn coord ->
        [x, y] = String.split(coord, ",", trim: true)
        {String.to_integer(x), String.to_integer(y)}
      end)
      |> MapSet.new()

    folds =
      Enum.map(folds, fn fold ->
        [axis, location] = String.split(fold, " ", trim: true) |> Enum.at(-1) |> String.split("=")

        {axis, String.to_integer(location)}
      end)

    {coords, folds}
  end

  def part1(input) do
    {coords, folds} = get_input(input)

    fold(coords, [hd(folds)]) |> Enum.count()
  end

  defp fold(coords, []), do: coords

  defp fold(coords, [{fold_axis, fold_location} | folds_tail]) do
    Enum.map(coords, fn {x, y} ->
      cond do
        fold_axis == "x" && x > fold_location ->
          {2 * fold_location - x, y}

        fold_axis == "y" && y > fold_location ->
          {x, 2 * fold_location - y}

        true ->
          {x, y}
      end
    end)
    |> MapSet.new()
    |> fold(folds_tail)
  end

  def part2(input) do
    {coords, folds} = get_input(input)
    coords = fold(coords, folds)
    {width, height} = get_grid_size(folds)

    for y <- 0..height, x <- 0..width do
      cond do
        x == width && MapSet.member?(coords, {x, y}) -> "#\n"
        x == width -> ".\n"
        MapSet.member?(coords, {x, y}) -> "#"
        true -> "."
      end
    end
    |> Enum.join()
  end

  defp get_grid_size(folds) do
    {_, max_x} =
      Enum.min_by(folds, fn {fold_axis, fold_location} -> fold_axis == "x" && fold_location end)

    {_, max_y} =
      Enum.min_by(folds, fn {fold_axis, fold_location} -> fold_axis == "y" && fold_location end)

    {max_x - 1, max_y - 1}
  end
end
