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
    {zero_count, _} = parse_input(input) |> move_dial
    zero_count
  end

  defp move_dial(rotations, current_pos \\ 50, zero_count \\ 0, passed_zero_count \\ 0)

  defp move_dial([], _, zero_count, passed_zero_count), do: {zero_count, passed_zero_count}

  defp move_dial([rotation | list], current_pos, zero_count, passed_zero_count) do
    {new_pos, new_passed_zero_count} = one_rotation(rotation, current_pos)
    new_zero_count = if(new_pos == 0, do: zero_count + 1, else: zero_count)
    move_dial(list, new_pos, new_zero_count, passed_zero_count + new_passed_zero_count)
  end

  # if we're starting at zero and moving left, this zero has already been counted, so pretend we're starting at 100
  defp one_rotation({"L", amount}, 0), do: rollover(100 - amount)
  defp one_rotation({"L", amount}, current_pos), do: rollover(current_pos - amount)
  defp one_rotation({"R", amount}, current_pos), do: rollover(current_pos + amount)

  defp rollover(position, zero_count \\ 0)

  defp rollover(position, zero_count) when position > 100 do
    rollover(position - 100, zero_count + 1)
  end

  defp rollover(position, zero_count) when position < 0 do
    rollover(position + 100, zero_count + 1)
  end

  # if the final is zero from moving right or left, we don't increase the zero count
  defp rollover(100, zero_count), do: {0, zero_count}
  defp rollover(position, zero_count), do: {position, zero_count}

  @doc """
    iex> part2(AoC2025.Day01.Input.test_input())
    6

    iex> part2(AoC2025.Day01.Input.input())
    5892
    # < 5895

  """
  def part2(input) do
    {stopped_zero_count, passed_zero_count} = parse_input(input) |> move_dial
    stopped_zero_count + passed_zero_count
  end
end
