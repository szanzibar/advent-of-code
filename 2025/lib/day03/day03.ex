defmodule AoC2025.Day03 do
  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      String.to_integer(line) |> Integer.digits()
    end)
  end

  @doc """
    iex> part1(AoC2025.Day03.Input.test_input())
    357

    iex> part1(AoC2025.Day03.Input.input())
    17524

  """
  def part1(input) do
    # the goal will be to iterate over each number. The 10s place will be the first largest number excluding the last
    # digit.
    # the second digit will be the largest number after the first.
    parse_input(input)
    |> Enum.map(&get_largest_joltage/1)
    |> Enum.sum()
  end

  def get_largest_joltage(ratings) do
    {list, [right_digit]} = Enum.split(ratings, -1)
    max = Enum.max(list)

    {_left, [largest_left_number | right_list]} = Enum.split_while(list, &(&1 < max))

    if right_list == [] do
      Integer.undigits([largest_left_number, right_digit])
    else
      full_right_list = right_list ++ [right_digit]
      max = Enum.max(full_right_list)

      {_left, [largest_right_number | _right_list]} =
        Enum.split_while(full_right_list, &(&1 < max))

      Integer.undigits([largest_left_number, largest_right_number])
    end
  end

  @doc """
    # iex> part2(AoC2025.Day03.Input.test_input())
    # nil

    # iex> part2(AoC2025.Day03.Input.input())
    # nil

  """
  def part2(input) do
    parse_input(input)
  end
end
