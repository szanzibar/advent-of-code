defmodule AoC2024.Day09 do
  @moduledoc """
  I have another situation where the example works fine and the real data doesn't.

  * I've done some spot checks and it appears that parsing the input is correct, after manually checking both ends
  * I've also done some spot checks of the moved list... and it appears everything is the correct spot.

  I've thought of a much more efficient way to do this, but I don't know if it's a step in the wrong direction for part 2.
  Eh. I think I'll just go for it. It should be a better way for part 2 I bet.

  new plan:
  * create parsed_input the same as now.
  * a reversed one
  * loop through list
    * split by first "."
    * split second section by first non "."
    * get count of empties
    * split reversed list by count of non "."
    * Place reversed section, empties removed, at end of first split from original list
    * Remove same section from end.

    God explaining the plan is too confusing let's just do it

  The new plan is much faster
  I had another problem where there was overlap of the very end, but is now resolved.
  """

  def parse_input(input) do
    input
    |> String.trim()
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(2)
    |> Enum.reduce({[], 0}, fn [size | space], {acc_list, acc_index} ->
      space =
        case space do
          [] -> 0
          [space] -> space
        end

      list = List.duplicate(acc_index, size)

      spaces = List.duplicate(".", space)

      {acc_list ++ list ++ spaces, acc_index + 1}
    end)
    |> then(fn {list, _} -> list end)
  end

  @doc """
    # iex> parse_input(AoC2024.Day09.Input.test_input()) |> Enum.join()
    # "00...111...2...333.44.5555.6666.777.888899"

    iex> part1(AoC2024.Day09.Input.test_input())
    1928

    iex> part1(AoC2024.Day09.Input.input())
    6398608069280
    # > 6398343689624
    # < 6398872404185

  """
  def part1(input) do
    list = parse_input(input) |> dbg
    reversed = list |> Enum.reverse()

    move_section(list, reversed, [])
    |> calculate_checksum()
  end

  def move_section([], _, acc), do: acc

  def move_section(list, reversed, acc) do
    {front, back} = Enum.split_while(list, &(&1 != "."))
    {empties, back} = Enum.split_while(back, &(&1 == "."))

    reversed = reversed |> Enum.drop((length(front) + length(empties)) * -1)

    {reversed, reversed_section} = take_while(reversed, length(empties), [])
    section_length = length(reversed_section)
    reversed_section = reversed_section |> Enum.reject(&(&1 == "."))
    back = back |> Enum.drop(section_length * -1)

    move_section(back, reversed, acc ++ front ++ reversed_section)
  end

  defp take_while(list, 0, acc), do: {list, Enum.reverse(acc)}
  defp take_while([], _, acc), do: {[], Enum.reverse(acc)}

  defp take_while(["." | list], count, acc) do
    take_while(list, count, ["." | acc])
  end

  defp take_while([hd | list], count, acc) do
    take_while(list, count - 1, [hd | acc])
  end

  defp calculate_checksum(list) do
    list
    |> Enum.with_index()
    |> Enum.map(fn {value, index} -> value * index end)
    |> Enum.sum()
  end

  defp print(list) do
    list
    |> Enum.join()
    |> IO.inspect()

    list
  end

  @doc """
    # iex> part2(AoC2024.Day09.Input.test_input())
    # nil

    # iex> part2(AoC2024.Day09.Input.input())
    # nil

  """
  def part2(input) do
    parse_input(input)
  end
end
