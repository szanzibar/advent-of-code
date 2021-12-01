defmodule AoC.SonarSweep do
  @spec sonar_sweep(binary()) :: integer()
  def sonar_sweep(file) when is_binary(file) do
    measurements =
      File.read!(Path.join(__DIR__, file))
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_integer(&1))

    sonar_sweep(measurements)
  end

  @spec sonar_sweep(list, integer(), integer()) :: integer()
  def sonar_sweep(measurements, previous \\ nil, total_increase \\ 0)

  def sonar_sweep([head | tail], previous, total_increase) do
    increase = if head > previous, do: 1, else: 0
    sonar_sweep(tail, head, total_increase + increase)
  end

  def sonar_sweep([], _previous, total_increase), do: total_increase
end
