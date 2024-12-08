defmodule AoC2024.Day08 do
  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, row_i} ->
      row
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.map(fn {char, col_i} ->
        {{row_i, col_i}, {char, nil}}
      end)
    end)
    |> Map.new()
  end

  @doc """
    iex> part1(AoC2024.Day08.Input.test_input())
    14

    iex> part1(AoC2024.Day08.Input.input())
    289

  """
  def part1(input) do
    map = parse_input(input) |> dbg
    distinct_frequencies = distinct_frequencies(map) |> dbg

    pairs_by_freq = get_freq_pairs(distinct_frequencies, map)

    map = build_antinode_map(pairs_by_freq, map)

    Enum.count(map, fn {_coord, {_freq, antinode}} -> !is_nil(antinode) end)
  end

  defp build_antinode_map(pairs_by_freq, map) do
    pairs_by_freq
    |> Enum.reduce(map, fn {_freq, pairs}, acc_map ->
      pairs
      |> Enum.reduce(acc_map, fn {{col1, row1}, {col2, row2}}, inner_acc_map ->
        col_offset = col1 - col2
        row_offset = row1 - row2
        new_coord1 = {col1 + col_offset, row1 + row_offset}
        new_coord2 = {col2 + col_offset * -1, row2 + row_offset * -1}

        inner_acc_map =
          Map.get(inner_acc_map, new_coord1)
          |> case do
            nil -> inner_acc_map
            {freq, _} -> Map.put(inner_acc_map, new_coord1, {freq, "#"})
          end

        inner_acc_map =
          inner_acc_map
          |> Map.get(new_coord2)
          |> case do
            nil -> inner_acc_map
            {freq, _} -> Map.put(inner_acc_map, new_coord2, {freq, "#"})
          end

        inner_acc_map
      end)
    end)
    |> print_map()
  end

  defp get_freq_pairs(frequencies, map) do
    Enum.map(frequencies, fn freq ->
      coords =
        get_freq_coords(freq, map)
        |> pair_recursion()
        |> dbg

      {freq, coords}
    end)
    |> Map.new()
  end

  defp pair_recursion(coords), do: pair_recursion(coords, [])
  defp pair_recursion([], acc), do: acc

  defp pair_recursion([hd | coords], acc) do
    pairs = Enum.map(coords, fn coord -> {hd, coord} end)

    pair_recursion(coords, pairs ++ acc)
  end

  defp get_freq_coords(freq, map) do
    Enum.filter(map, fn {_, {freq_char, _}} ->
      freq_char == freq
    end)
    |> Enum.map(fn {coord, _} -> coord end)
  end

  defp distinct_frequencies(map) do
    Enum.map(map, fn {_, {freq, _}} -> freq end) |> Enum.uniq() |> Enum.reject(&(&1 == "."))
  end

  defp print_map(map) when is_map(map) do
    Enum.sort_by(map, fn {coord, _} -> coord end)
    |> Enum.chunk_by(fn {{row, _col}, _} -> row end)
    |> Enum.map(fn row ->
      row
      |> Enum.map(fn {_coord, {_freq, antinode}} -> antinode || " " end)
      |> Enum.join(" ")
      |> IO.inspect()
    end)

    map
  end

  defp print_map(what), do: what

  @doc """
    # iex> part2(AoC2024.Day08.Input.test_input())
    # nil

    # iex> part2(AoC2024.Day08.Input.input())
    # nil

  """

  def part2(input) do
    parse_input(input)
  end
end
