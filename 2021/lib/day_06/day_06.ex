defmodule AoC.Day06 do
  defp get_input(file) do
    File.read!(Path.join(__DIR__, file))
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer(&1))
  end

  def part1(input) do
    get_input(input) |> next_day(0) |> Enum.count()
  end

  defp next_day(fishes, day) when day == 80, do: fishes

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

  def part2(input) do
    list = get_input(input)

    counts =
      for x <- 0..8, into: [] do
        Enum.count(list, &(&1 == x))
      end

    counts |> next_day_new(0, 0, 0)
  end

  defp next_day_new(fish_count, day, sevens, eights) when day == 256 do
    Enum.sum(fish_count) + sevens + eights
  end

  defp next_day_new(fish_count, day, sevens, eights) do
    zero_at = rem(day, 7)
    zero_count = Enum.at(fish_count, zero_at)

    List.replace_at(fish_count, zero_at, zero_count + sevens)
    |> next_day_new(day + 1, eights, zero_count)
  end
end
