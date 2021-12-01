defmodule AoC.SonarSweep do
  defp get_measurements(file) do
    File.read!(Path.join(__DIR__, file))
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  @spec part1(binary()) :: integer()
  def part1(file) when is_binary(file), do: get_measurements(file) |> part1()

  @spec part1(list()) :: integer()
  def part1(list) when is_list(list) do
    Enum.chunk_every(list, 2, 1, :discard) |> Enum.count(fn [a, b] -> b > a end)
  end

  @spec part2(binary()) :: integer()
  def part2(file) do
    get_measurements(file) |> Enum.chunk_every(3, 1, :discard) |> Enum.map(&Enum.sum/1) |> part1()
  end
end
