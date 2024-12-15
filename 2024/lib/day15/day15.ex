defmodule AoC2024.Day15 do
  def parse_input(input) do
    [grid, moves] = input |> String.trim() |> String.split("\n\n")

    grid =
      grid
      |> String.split("\n")
      |> Enum.with_index()
      |> Enum.flat_map(fn {line, row_index} ->
        line
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.map(fn {character, col_index} ->
          {{row_index, col_index}, character}
        end)
      end)
      |> Map.new()

    moves = String.replace(moves, "\n", "") |> String.graphemes()

    {grid, moves}
  end

  @doc """
    iex> part1(AoC2024.Day15.Input.test_input())
    2028

    iex> part1(AoC2024.Day15.Input.test_input2())
    10092

    # iex> part1(AoC2024.Day15.Input.input())
    # 1526673

  """
  def part1(input) do
    {grid, moves} = parse_input(input)
    moved_grid = move_robot(grid, moves)
    sum_gps_coords(moved_grid)
  end

  defp sum_gps_coords(moved_grid) do
    Enum.filter(moved_grid, fn {_coord, object} -> object == "O" end)
    |> Enum.map(fn {{row, col}, _} ->
      100 * row + col
    end)
    |> Enum.sum()
  end

  defp move_robot(grid, []), do: grid

  defp move_robot(grid, [move | moves]) do
    {robot_coord, robot} = Enum.find(grid, fn {_, robot} -> robot == "@" end)

    {_, grid} = push_object(grid, robot_coord, move, robot)
    move_robot(grid, moves)
  end

  defp push_object(grid, coord, direction, object) do
    next_coord = next_coord(coord, direction)
    next_object = Map.get(grid, next_coord)

    case next_object do
      "#" ->
        {false, grid}

      "." ->
        # move to this location, backfill previous location to "."
        {true, Map.put(grid, coord, ".") |> Map.put(next_coord, object)}

      "O" ->
        push_object(grid, next_coord, direction, "O")
        |> case do
          {false, grid} ->
            {false, grid}

          {true, pushed_grid} ->
            {true, Map.put(pushed_grid, coord, ".") |> Map.put(next_coord, object)}
        end
    end
  end

  defp next_coord({row, col}, direction) do
    {row_offset, col_offset} = coord_offset(direction)
    {row + row_offset, col + col_offset}
  end

  defp coord_offset("<"), do: {0, -1}
  defp coord_offset("^"), do: {-1, 0}
  defp coord_offset(">"), do: {0, 1}
  defp coord_offset("v"), do: {1, 0}

  defp print_map(map) do
    IO.inspect("")

    Enum.sort_by(map, fn {coord, _} -> coord end)
    |> Enum.chunk_by(fn {{row, _col}, _} -> row end)
    |> Enum.map(fn row ->
      row |> Enum.map(fn {_coord, value} -> value end) |> Enum.join("") |> IO.inspect()
    end)

    map
  end

  # PART 2
  def parse_input2(input) do
    [grid, moves] = input |> String.trim() |> String.split("\n\n")

    grid =
      grid
      |> String.split("\n")
      |> Enum.with_index()
      |> Enum.flat_map(fn {line, row_index} ->
        line
        |> String.graphemes()
        |> Enum.flat_map(fn grapheme ->
          case grapheme do
            "#" -> ["#", "#"]
            "O" -> ["[", "]"]
            "." -> [".", "."]
            "@" -> ["@", "."]
          end
        end)
        |> Enum.with_index()
        |> Enum.map(fn {character, col_index} ->
          {{row_index, col_index}, character}
        end)
      end)
      |> Map.new()

    moves = String.replace(moves, "\n", "") |> String.graphemes()

    {grid, moves}
  end

  @doc """
    iex> part2(AoC2024.Day15.Input.test_input3())
    nil

    # iex> part2(AoC2024.Day15.Input.test_input2())
    # nil

    # iex> part2(AoC2024.Day15.Input.input())
    # nil

  """
  def part2(input) do
    {grid, moves} = parse_input2(input)
    print_map(grid)
    moved_grid = move_robot2(grid, moves)
    sum_gps_coords(moved_grid)
  end

  defp move_robot2(grid, []), do: grid

  defp move_robot2(grid, [move | moves]) do
    {robot_coord, robot} = Enum.find(grid, fn {_, robot} -> robot == "@" end)

    {_, grid} = push_object2(grid, robot_coord, move, robot)
    move_robot2(grid, moves)
  end

  defp push_object2(grid, coord, direction, object) do
    next_coord2 = next_coord2(coord, direction)
    next_object = Map.get(grid, next_coord2)

    case next_object do
      "#" ->
        {false, grid}

      "." ->
        # move to this location, backfill previous location to "."
        {true, Map.put(grid, coord, ".") |> Map.put(next_coord2, object)}

      "O" ->
        push_object2(grid, next_coord2, direction, "O")
        |> case do
          {false, grid} ->
            {false, grid}

          {true, pushed_grid} ->
            {true, Map.put(pushed_grid, coord, ".") |> Map.put(next_coord2, object)}
        end
    end
  end

  defp next_coord2({row, col}, direction) do
    {row_offset, col_offset} = coord_offset2(direction)
    {row + row_offset, col + col_offset}
  end

  defp coord_offset2("<"), do: {0, -1}
  defp coord_offset2("^"), do: {-1, 0}
  defp coord_offset2(">"), do: {0, 1}
  defp coord_offset2("v"), do: {1, 0}
end
