defmodule AoC.Day07 do
  defp get_input(file) do
    File.read!(Path.join(__DIR__, file))
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer(&1))
  end

  def part1(input) do
    list = get_input(input)
    find_position(list)
  end

  defp find_position(list) do
    sorted = Enum.sort(list)
    zero_cost = calculate_fuel(sorted, 0)
    find_position(sorted, zero_cost, 0, Enum.count(sorted))
  end

  defp find_position(list, current_cost, min, max) do
    min |> IO.inspect(label: "min")
    max |> IO.inspect(label: "max")
    mid = ((max + min) / 2) |> round() |> IO.inspect(label: "mid")
    mid_cost = calculate_fuel(list, Enum.at(list, mid)) |> IO.inspect(label: "mid cost")
    current_cost |> IO.inspect(label: "current cost")

    cond do
      mid < 0 ->
        mid

      mid_cost == current_cost ->
        calculate_fuel(list, Enum.at(list, mid))

      mid_cost > current_cost ->
        find_position(list, current_cost, min, mid - 1)

      mid_cost < current_cost ->
        find_position(list, mid_cost, mid, max)
    end
  end

  def fuel(input, number) do
    get_input(input) |> calculate_fuel(number)
  end

  defp calculate_fuel(list, align) do
    Enum.map(list, fn x ->
      abs(x - align)
    end)
    |> Enum.sum()
  end

  def part2(input) do
    input |> IO.inspect()
  end
end
