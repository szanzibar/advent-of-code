defmodule AoC2025.Day01 do
  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn line ->
      {direction, amount} = String.split_at(line, 1)

      {direction, String.to_integer(amount)}
    end)
  end

  @doc """
    iex> part1(AoC2025.Day01.Input.test_input())
    3

    iex> part1(AoC2025.Day01.Input.input())
    1029

  """
  def part1(input) do
    parse_input(input) |> move_dial
  end

  defp move_dial(rotations, current_pos \\ 50, zero_count \\ 0)
  defp move_dial([], _, zero_count), do: zero_count

  defp move_dial([rotation | list], current_pos, zero_count) do
    new_pos = one_rotation(rotation, current_pos)
    new_zero_count = if(new_pos == 0, do: zero_count + 1, else: zero_count)
    move_dial(list, new_pos, new_zero_count)
  end

  defp one_rotation({"L", amount}, current_pos) do
    Integer.mod(-amount + current_pos, 100)
  end

  defp one_rotation({"R", amount}, current_pos) do
    Integer.mod(amount + current_pos, 100)
  end

  @doc """
    iex> part2(AoC2025.Day01.Input.test_input())
    6

    # iex> part2(AoC2025.Day01.Input.input())
    # nil

  """
  def part2(input) do
    parse_input(input) |> move_dial
  end
end
