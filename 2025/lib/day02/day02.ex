defmodule AoC2025.Day02 do
  def parse_input(input) do
    input
    |> String.trim()
    |> String.split(",")
    |> Enum.flat_map(fn range ->
      [start, finish] = String.split(range, "-")

      String.to_integer(start)..String.to_integer(finish)
      |> Enum.to_list()
      |> Enum.map(&Integer.to_string/1)
    end)
  end

  @doc """
    iex> part1(AoC2025.Day02.Input.test_input())
    1227775554

    iex> part1(AoC2025.Day02.Input.input())
    23039913998

  """
  def part1(input) do
    parse_input(input)
    |> Enum.map(fn number ->
      String.split_at(number, Integer.floor_div(String.length(number), 2))
    end)
    |> Enum.filter(fn {left, right} -> left == right end)
    |> Enum.map(fn {left, right} ->
      (left <> right) |> String.to_integer()
    end)
    |> Enum.sum()
  end

  @doc """
    iex> part2(AoC2025.Day02.Input.test_input())
    4174379265

    # iex> part2(AoC2025.Day02.Input.input())
    # nil

  """
  def part2(input) do
    parse_input(input)
    |> Enum.map(fn number ->
      max_pattern_length = Integer.floor_div(String.length(number), 2) |> dbg
      String.split_at(number, Integer.floor_div(String.length(number), 2))
    end)
  end
end
