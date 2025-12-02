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
    |> Stream.map(fn number ->
      String.split_at(number, Integer.floor_div(String.length(number), 2))
    end)
    |> Stream.filter(fn {left, right} -> left == right end)
    |> Stream.map(fn {left, right} ->
      (left <> right) |> String.to_integer()
    end)
    |> Enum.sum()
  end

  @doc """
    iex> part2(AoC2025.Day02.Input.test_input())
    4174379265

    iex> part2(AoC2025.Day02.Input.input())
    35950619148

  """
  def part2(input) do
    parse_input(input)
    |> Stream.reject(fn number ->
      # gonna start by trimming down the list by deleting numbers that can't possibly have patterns
      # to decrease the amount of patterns we have to check.
      # It can't have any duplicate patterns if there are more unique digits than half of the length
      max_pattern_length = Integer.floor_div(String.length(number), 2)
      unique_digits_count = String.graphemes(number) |> Enum.uniq() |> length()
      unique_digits_count > max_pattern_length
    end)
    |> Stream.filter(fn number ->
      max_pattern_length = Integer.floor_div(String.length(number), 2)

      Enum.any?(
        # duplicate each possible substring as many times as it fits in the length and see if it matches the number
        for length <- 1..max_pattern_length do
          slice = String.slice(number, 0, length)
          duplicate_length = Integer.floor_div(String.length(number), length)
          invalid_id = String.duplicate(slice, duplicate_length)
          invalid_id == number
        end
      )
    end)
    |> Stream.map(&String.to_integer/1)
    |> Enum.sum()
  end
end
