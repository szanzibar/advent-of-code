defmodule AoC2023.Day09 do
  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn line ->
      String.split(line, " ") |> Enum.map(&String.to_integer/1) |> Enum.reverse()
    end)
  end

  @doc """
    iex> part1(AoC2023.Day09.Input.test_input())
    114

    iex> part1(AoC2023.Day09.Input.input())
    1938731307

  """
  def part1(input) do
    parse_input(input)
    |> Enum.map(fn history ->
      extrapolate(history, [], [history])
      |> Enum.reduce(0, fn [hd | _sequence], acc ->
        acc + hd
      end)
    end)
    |> Enum.sum()
  end

  def extrapolate([_], derivative, derivatives) do
    finished_derivative = derivative |> Enum.reverse()
    [a | _tail] = finished_derivative

    if Enum.all?(finished_derivative, &(&1 == a)) do
      [finished_derivative | derivatives]
    else
      extrapolate(finished_derivative, [], [finished_derivative | derivatives])
    end
  end

  def extrapolate([a, b | tail], derivative, derivatives) do
    extrapolate([b | tail], [a - b | derivative], derivatives)
  end

  @doc """
    iex> part2(AoC2023.Day09.Input.test_input())
    2

    iex> part2(AoC2023.Day09.Input.input())
    948

  """
  def part2(input) do
    parse_input(input)
    |> Enum.map(fn history ->
      extrapolate(history, [], [history])
      |> Enum.map(&Enum.reverse/1)
      |> Enum.reduce(0, fn [hd | _sequence], acc ->
        hd - acc
      end)
    end)
    |> Enum.sum()
  end

  def part2_async(input) do
    parse_input(input)
    |> Enum.map(fn history ->
      Task.async(fn ->
        extrapolate(history, [], [history])
        |> Enum.map(&Enum.reverse/1)
        |> Enum.reduce(0, fn [hd | _sequence], acc ->
          hd - acc
        end)
      end)
    end)
    |> Task.await_many()
    |> Enum.sum()
  end
end
