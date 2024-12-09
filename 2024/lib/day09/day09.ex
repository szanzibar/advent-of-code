defmodule AoC2024.Day09 do
  @moduledoc """
  I have another situation where the example works fine and the real data doesn't.

  * I've done some spot checks and it appears that parsing the input is correct, after manually checking both ends
  * I've also done some spot checks of the moved list... and it appears everything is the correct spot.

  I've thought of a much more efficient way to do this, but I don't know if it's a step in the wrong direction for part 2.
  Eh. I think I'll just go for it. It should be a better way for part 2 I bet.
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
    iex> parse_input(AoC2024.Day09.Input.test_input()) |> Enum.join()
    "00...111...2...333.44.5555.6666.777.888899"

    iex> part1(AoC2024.Day09.Input.test_input())
    1928

    iex> part1(AoC2024.Day09.Input.input())
    nil
    > 6398343689624

  """
  def part1(input) do
    list = parse_input(input) |> dbg
    list |> Enum.reverse() |> dbg
    move_right_to_empty(list) |> calculate_checksum
    # move_right_to_empty(map) |> print |> calculate_checksum()
  end

  defp calculate_checksum(list) do
    list
    |> Enum.with_index()
    |> Enum.map(fn {value, index} -> value * index end)
    |> Enum.sum()
    |> dbg
  end

  defp move_right_to_empty(list) do
    min_empty_index = get_min_empty_index(list)

    if is_nil(min_empty_index) do
      list
    else
      {popped, list} = pop_top(list)
      List.replace_at(list, min_empty_index, popped) |> move_right_to_empty()
    end
  end

  defp get_min_empty_index(list) do
    Enum.find_index(list, &(&1 == "."))
  end

  defp pop_top(list) do
    {popped, list} = List.pop_at(list, -1)

    if popped == "." do
      pop_top(list)
    else
      {popped, list}
    end
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
