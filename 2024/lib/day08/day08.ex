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
    map = parse_input(input)
    distinct_frequencies = distinct_frequencies(map)

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

        add_antinode_list(inner_acc_map, [new_coord1, new_coord2])
      end)
    end)
  end

  defp get_freq_pairs(frequencies, map) do
    Enum.map(frequencies, fn freq ->
      coords =
        get_freq_coords(freq, map)
        |> pair_recursion()

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
    iex> part2(AoC2024.Day08.Input.test_input())
    34

    iex> part2(AoC2024.Day08.Input.input())
    1030

  """

  def part2(input) do
    map = parse_input(input)
    distinct_frequencies = distinct_frequencies(map)

    pairs_by_freq = get_freq_pairs(distinct_frequencies, map)

    map = build_antinode_map2(pairs_by_freq, map)

    Enum.count(map, fn {_coord, {_freq, antinode}} -> !is_nil(antinode) end)
  end

  defp build_antinode_map2(pairs_by_freq, map) do
    {{max_col, _}, _} = Enum.max_by(map, fn {{col, _}, _} -> col end)
    {{_, max_row}, _} = Enum.max_by(map, fn {{_, row}, _} -> row end)

    pairs_by_freq
    |> Enum.reduce(map, fn {_freq, pairs}, acc_map ->
      pairs
      |> Enum.reduce(acc_map, fn {{col1, row1}, {col2, row2}}, inner_acc_map ->
        col_offset = col1 - col2
        row_offset = row1 - row2

        new_coords_pos =
          next_coord({col2, row2}, {col_offset, row_offset}, {max_col, max_row}, [])

        new_coords_neg =
          next_coord({col1, row1}, {col_offset * -1, row_offset * -1}, {max_col, max_row}, [])

        add_antinode_list(inner_acc_map, new_coords_pos ++ new_coords_neg)
      end)
    end)
    |> print_map()
  end

  defp next_coord({col, row}, {c_offset, r_offset}, {c_max, r_max}, acc)
       when col + c_offset > c_max or row + r_offset > r_max or col + c_offset < 0 or
              row + r_offset < 0,
       do: acc

  defp next_coord({col, row}, {c_offset, r_offset}, maxes, acc) do
    new_coord = {col + c_offset, row + r_offset}
    new_acc = [new_coord | acc]

    next_coord(new_coord, {c_offset, r_offset}, maxes, new_acc)
  end

  defp add_antinode_list(map, coords) do
    Enum.reduce(coords, map, fn coord, acc_map ->
      add_antinode(acc_map, coord)
    end)
  end

  defp add_antinode(map, coord) do
    Map.get(map, coord)
    |> case do
      nil -> map
      {freq, _} -> Map.put(map, coord, {freq, "#"})
    end
  end
end
