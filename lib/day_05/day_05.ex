defmodule AoC.Day05 do
  defp get_input(file) do
    File.read!(Path.join(__DIR__, file))
    |> String.split("\n")
    |> Enum.map(fn segment ->
      String.split(segment, " -> ")
      |> Enum.map(fn coord ->
        [x, y] = String.split(coord, ",")
        %{x: String.to_integer(x), y: String.to_integer(y)}
      end)
    end)
  end

  def part1(input) do
    get_input(input)
    |> Enum.filter(fn [start, end_point] ->
      start.x == end_point.x || start.y == end_point.y
    end)
    |> calculate_intersections()
  end

  def part2(input) do
    get_input(input) |> calculate_intersections()
  end

  defp calculate_intersections(points) do
    points
    |> Enum.flat_map(fn segment ->
      line_points(segment, [])
    end)
    |> Enum.sort()
    |> Enum.chunk_by(& &1)
    |> Enum.filter(&(Enum.count(&1) > 1))
    |> Enum.count()
  end

  defp line_points([start, end_point], points) when start == end_point do
    [end_point | points]
  end

  defp line_points([start, end_point], points) do
    x_change = get_coord_change(start.x, end_point.x)
    y_change = get_coord_change(start.y, end_point.y)

    point = %{x: start.x + x_change, y: start.y + y_change}
    line_points([point, end_point], [start | points])
  end

  defp get_coord_change(first, last) do
    case last - first do
      n when n > 0 -> 1
      n when n == 0 -> 0
      n when n < 0 -> -1
    end
  end
end
