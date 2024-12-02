defmodule AoC2024.Day01 do
  def parse_input(input) do
    {left, right} =
      input
      |> String.trim()
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        String.split(line, "   ", trim: true) |> Enum.map(&String.to_integer/1) |> List.to_tuple()
      end)
      |> Enum.unzip()

    left = Enum.sort(left)
    right = Enum.sort(right)

    {left, right}
  end

  @doc """
    iex> part1(AoC2024.Day01.Input.test_input())
    11

    iex> part1(AoC2024.Day01.Input.input())
    2367773

  """
  def part1(input) do
    {left, right} = parse_input(input)

    Enum.zip(left, right)
    |> Enum.map(fn {l, r} ->
      abs(l - r)
    end)
    |> Enum.sum()
  end

  @doc """
    iex> part2(AoC2024.Day01.Input.test_input())
    31

    iex> part2(AoC2024.Day01.Input.input())
    21271939

  """
  def part2(input) do
    {left, right} = parse_input(input)

    frequencies =
      Enum.frequencies(right)
      |> Map.new(fn {num, freq} ->
        {num, freq * num}
      end)

    Enum.map(left, fn left_int ->
      Map.get(frequencies, left_int, 0)
    end)
    |> Enum.sum()
  end
end
