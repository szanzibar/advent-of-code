defmodule AoC.Day07 do
  defp get_input(file) do
    File.read!(Path.join(__DIR__, file))
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer(&1))
  end

  def part1(input) do
    calculate_fuel = fn list, align ->
      Enum.reduce(list, 0, &(abs(&1 - align) + &2))
    end

    get_input(input)
    |> find_position(calculate_fuel)
  end

  defp find_position(list, calculate) do
    sorted = Enum.sort(list)

    find_position(
      sorted,
      Enum.at(sorted, 0),
      Enum.at(sorted, Enum.count(sorted) - 1),
      calculate
    )
  end

  defp find_position(list, min, max, calculate) do
    mid = ((max + min) / 2) |> round()
    mid_cost = calculate.(list, mid)
    cost_above = calculate.(list, mid + 1)
    cost_below = calculate.(list, mid - 1)

    cond do
      mid_cost <= cost_above && mid_cost <= cost_below ->
        mid_cost

      cost_above > mid_cost ->
        find_position(list, min, mid, calculate)

      cost_below > mid_cost ->
        find_position(list, mid, max, calculate)
    end
  end

  def part2(input) do
    calculate_fuel = fn list, align ->
      Enum.reduce(list, 0, fn n, acc ->
        distance = abs(n - align)
        round((Integer.pow(distance, 2) + distance) / 2) + acc
      end)
    end

    get_input(input)
    |> find_position(calculate_fuel)
  end
end
