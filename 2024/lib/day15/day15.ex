defmodule AoC2024.Day15 do
  import Utils

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

    iex> part1(AoC2024.Day15.Input.input())
    1526673

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

    grid = push_object_moves(grid, robot_coord, move, robot) |> push_object(grid)

    move_robot(grid, moves)
  end

  defp push_object(false, moves), do: moves

  defp push_object({true, moves}, grid) do
    {deletes, moves} = Enum.split_with(moves, fn {_coord, char} -> char == "." end)

    grid =
      Enum.reduce(deletes, grid, fn {coord, object}, grid_acc ->
        Map.put(grid_acc, coord, object)
      end)

    Enum.reduce(moves, grid, fn {coord, object}, grid_acc ->
      Map.put(grid_acc, coord, object)
    end)
  end

  defp push_object_moves(grid, coord, direction, object) do
    next_coord = next_coord(coord, direction)
    next_object = Map.get(grid, next_coord)

    case next_object do
      "#" ->
        false

      "." ->
        # move to this location, backfill previous location to "."
        {true, [{coord, "."}, {next_coord, object}]}

      next_object when next_object in ["[", "]"] and direction in ["^", "v"] ->
        other_next_object = if next_object == "[", do: "]", else: "["
        other_next_coord = get_other_part_coord(next_coord, next_object)

        next_result = push_object_moves(grid, next_coord, direction, next_object)
        other_result = push_object_moves(grid, other_next_coord, direction, other_next_object)

        case {next_result, other_result} do
          {{true, next}, {true, other}} ->
            my_moves = [{coord, "."}, {next_coord, object}, {other_next_coord, "."}]
            all_moves = my_moves ++ next ++ other

            {true, all_moves}

          _ ->
            false
        end

      next_object when next_object in ["O", "[", "]"] ->
        push_object_moves(grid, next_coord, direction, next_object)
        |> case do
          false ->
            false

          {true, list_of_moves} ->
            {true, [{coord, "."}, {next_coord, object} | list_of_moves]}
        end
    end
  end

  defp get_other_part_coord(coord, "["), do: next_coord(coord, ">")
  defp get_other_part_coord(coord, "]"), do: next_coord(coord, "<")

  defp next_coord({row, col}, direction) do
    {row_offset, col_offset} = coord_offset(direction)
    {row + row_offset, col + col_offset}
  end

  defp coord_offset("<"), do: {0, -1}
  defp coord_offset("^"), do: {-1, 0}
  defp coord_offset(">"), do: {0, 1}
  defp coord_offset("v"), do: {1, 0}

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
    iex> part2(AoC2024.Day15.Input.test_input2())
    9021

    iex> part2(AoC2024.Day15.Input.input())
    1535509

  """
  def part2(input) do
    {grid, moves} = parse_input2(input)
    print_map(grid)
    moved_grid = move_robot(grid, moves) |> print_map()
    sum_gps_coords2(moved_grid)
  end

  defp sum_gps_coords2(moved_grid) do
    Enum.filter(moved_grid, fn {_coord, object} -> object == "[" end)
    |> Enum.map(fn {{row, col}, _} ->
      100 * row + col
    end)
    |> Enum.sum()
  end
end
