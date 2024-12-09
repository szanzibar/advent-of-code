defmodule AoC2024.Day09 do
  def parse_input(input) do
    input
    |> String.trim()
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(2)
    |> dbg
    |> Enum.reduce({%{}, 0, 0}, fn [size | space], {acc_map, acc_index, acc_id} ->
      space =
        case space do
          [] -> 0
          [space] -> space
        end

      space_index = size + acc_index

      map =
        acc_index..(space_index - 1)
        |> Enum.reduce(acc_map, fn index, map ->
          Map.put(map, index, acc_id)
        end)

      map =
        if space > 0 do
          space_index..(space_index + space - 1)
          |> Enum.reduce(map, fn index, map ->
            Map.put(map, index, ".")
          end)
        else
          map
        end

      {map, space_index + space, acc_id + 1}
    end)
    |> then(fn {map, _, _} -> map end)
    |> dbg
  end

  @doc """
    iex> part1(AoC2024.Day09.Input.test_input())
    1928

    iex> part1(AoC2024.Day09.Input.input())
    nil

  """
  def part1(input) do
    map = parse_input(input)
    move_right_to_empty(map) |> print |> calculate_checksum()
  end

  defp calculate_checksum(map) do
    Enum.map(map, fn {key, value} -> key * value end) |> Enum.sum() |> dbg
  end

  defp move_right_to_empty(map) do
    min_empty = get_min_empty(map)

    dbg(min_empty)

    if is_nil(min_empty) do
      map
    else
      {popped, map} = pop_top(map)
      Map.put(map, min_empty, popped) |> move_right_to_empty()
    end
  end

  defp get_min_empty(map) do
    {first_empty_index, _} =
      map
      |> Enum.filter(fn {_key, value} -> value == "." end)
      |> Enum.min_by(
        fn
          {key, _value} -> key
        end,
        &<=/2,
        fn -> {nil, nil} end
      )

    first_empty_index
  end

  defp get_max_index(map), do: map_size(map) - 1

  defp pop_top(map) do
    {popped, map} = Map.pop(map, get_max_index(map))

    if popped == "." do
      pop_top(map)
    else
      {popped, map}
    end
  end

  defp print(map) do
    Map.to_list(map)
    |> Enum.sort()
    |> Enum.map(fn {_k, val} -> val end)
    |> Enum.join()
    |> IO.inspect()

    map
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
