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

  defp get_largest_joltage(ratings) do
    get_largest_left(ratings, 2, [])
  end

  @doc """
    iex> part2(AoC2025.Day03.Input.test_input())
    3121910778619

    iex> part2(AoC2025.Day03.Input.input())
    173848577117276

  """
  def part2(input) do
    parse_input(input)
    |> Enum.map(&get_largest_joltage_2/1)
    |> Enum.sum()
  end

  defp get_largest_joltage_2(ratings) do
    # need to get the largest possibility for each place of 12
    # need to remove n-1 digits from the right, get the largest from the left.
    # Then do the same thing with the right list with (n-1)-1

    get_largest_left(ratings, 12, [])
  end

  defp get_largest_left(_ratings, 0, digits_acc),
    do: Enum.reverse(digits_acc) |> Integer.undigits()

  defp get_largest_left(ratings, amount_from_right, digits_acc) do
    {list, split_right_digits} = split(ratings, amount_from_right)
    max = Enum.max(list)

    {_discard_left, [largest_left_number | right_list]} = Enum.split_while(list, &(&1 < max))

    get_largest_left(right_list ++ split_right_digits, amount_from_right - 1, [
      largest_left_number | digits_acc
    ])
  end

  defp split(ratings, 1) do
    {ratings, []}
  end

  defp split(ratings, amount_from_right) do
    Enum.split(ratings, 1 - amount_from_right)
  end
end
