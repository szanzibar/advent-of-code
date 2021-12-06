defmodule AoC.Day06 do
  defp get_input(file) do
    File.read!(Path.join(__DIR__, file))
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer(&1))
  end

  def part1(input) do
    get_input(input) |> next_day(0) |> Enum.count()
  end

  defp next_day(fishes, 80), do: fishes

  defp next_day(fishes, day) do
    Enum.flat_map(fishes, fn fish ->
      case fish do
        0 ->
          [6, 8]

        _ ->
          [fish - 1]
      end
    end)
    |> next_day(day + 1)
  end

  def part2(_input), do: nil
end
