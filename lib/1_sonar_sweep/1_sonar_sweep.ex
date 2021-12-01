defmodule AoC.SonarSweep do
  defp read_measurements_file(file) do
    File.read!(Path.join(__DIR__, file))
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer(&1))
  end

  @spec increases(binary()) :: integer()
  def increases(file) when is_binary(file), do: increases(read_measurements_file(file))

  @spec increases(list, integer(), integer()) :: integer()
  def increases(measurements, previous \\ nil, total_increase \\ 0)

  def increases([head | tail], previous, total_increase) do
    increase = if head > previous, do: 1, else: 0
    increases(tail, head, total_increase + increase)
  end

  def increases([], _previous, total_increase), do: total_increase

  @spec window_increases(binary()) :: integer()
  def window_increases(file) when is_binary(file),
    do: window_increases(read_measurements_file(file))

  @spec window_increases(list, integer(), integer()) :: integer()
  def window_increases(measurements, previous \\ nil, total_increase \\ 0)

  def window_increases([_a, _b], _previous, total_increase), do: total_increase

  def window_increases(measurements, previous, total_increase) do
    [_head | tail] = measurements
    sum = Enum.take(measurements, 3) |> Enum.sum()
    increase = if sum > previous, do: 1, else: 0
    window_increases(tail, sum, total_increase + increase)
  end
end
