defmodule AoC2024.Day12 do
  @moduledoc """
  Had a lot of false starts and rewriting today.

  I kept messing up the get_all_similar function where it didn't correctly remove
  already discovered regions and got stuck in infinite loops. I finally
  started over from scratch and was able to write it much cleaner.
  Mistakes and complexity had already accumulated making it impossible
  to keep all the logic of the function in my head, so starting over ended up being faster.
  Tech debt in 20 minutes basically.

  Then with part 2 it took me a few tries to think of a simple solution to count the sides.
  Quite happy with what I landed on, to create 4 corner points for every box, deduplicate the
  corners to get polygon corners, then 1 corner = 1 polygon side.
  """

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, row_i} ->
      row
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.map(fn {plant, col_i} ->
        {{row_i, col_i}, plant}
      end)
    end)
  end

  @doc """
    iex> part1(AoC2024.Day12.Input.test_input1())
    140

    iex> part1(AoC2024.Day12.Input.test_input2())
    1930

    iex> part1(AoC2024.Day12.Input.input())
    1461752

  """
  def part1(input) do
    keyword_list = parse_input(input)
    map = Map.new(keyword_list)

    chunks = get_next_chunk(map, [])

    Enum.map(chunks, fn chunk ->
      perimeter = get_perimeter(chunk)
      area = length(chunk)

      perimeter * area
    end)
    |> Enum.sum()
  end

  defp get_perimeter(coords) do
    map = Map.new(coords)

    Enum.reduce(coords, 0, fn {coord, _}, acc ->
      perimeter_sum =
        coord
        |> next_coords
        |> Enum.map(fn next_coord ->
          if is_nil(Map.get(map, next_coord)) do
            1
          else
            0
          end
        end)
        |> Enum.sum()

      perimeter_sum + acc
    end)
  end

  defp get_next_chunk(map, acc) when map_size(map) == 0, do: acc

  defp get_next_chunk(map, acc) do
    next = map |> Map.to_list() |> List.first()

    {coords, map} = get_all_similar(next, map)
    acc = [coords | acc]
    get_next_chunk(map, acc)
  end

  defp get_all_similar(coord, map) do
    coords = get_all_similar(coord, map, [coord]) |> Enum.uniq()
    map = Map.drop(map, Enum.map(coords, &elem(&1, 0)))

    {coords, map}
  end

  defp get_all_similar({coord, plant}, map, acc) do
    founds =
      coord
      |> next_coords()
      |> Enum.map(fn next_coord ->
        if Map.get(map, next_coord) == plant do
          {next_coord, plant}
        else
          nil
        end
      end)
      |> Enum.reject(&is_nil/1)
      |> Enum.reject(&(&1 in acc))

    all_founds = founds ++ acc

    founds
    |> Enum.reduce(all_founds, fn next_coord, acc_found_list ->
      get_all_similar(next_coord, map, acc_found_list)
    end)
  end

  defp next_coords({row, col}) do
    [{-1, 0}, {0, 1}, {1, 0}, {0, -1}]
    |> Enum.map(fn {row_offset, col_offset} ->
      {row_offset + row, col_offset + col}
    end)
  end

  @doc """
    iex> part2(AoC2024.Day12.Input.test_input1())
    80

    iex> part2(AoC2024.Day12.Input.test_input2())
    1206

    iex> part2(AoC2024.Day12.Input.test_input3())
    368

    iex> part2(AoC2024.Day12.Input.test_input4())
    236

    iex> part2(AoC2024.Day12.Input.input())
    904114

  """
  def part2(input) do
    keyword_list = parse_input(input)
    map = Map.new(keyword_list)

    chunks = get_next_chunk(map, [])

    Enum.map(chunks, fn chunk ->
      corners = count_polygon_sides(chunk)
      area = length(chunk)

      corners * area
    end)
    |> Enum.sum()
  end

  defp count_polygon_sides(chunk) do
    get_polygon(chunk) |> Enum.count()
    # oh shit it's just a count of corners??
  end

  defp get_polygon(chunk) do
    # convert every coord to a square with points in each corner
    Enum.flat_map(chunk, fn {{row, col} = coord, _} ->
      # coord is now the top left corner of the box
      [
        {{row, col}, coord},
        {{row, col + 1}, coord},
        {{row + 1, col}, coord},
        {{row + 1, col + 1}, coord}
      ]
    end)
    # if there is 1 distinct corner, that's a polygon corner
    # if there are 2 of a corner, it's an outside edge, and needs to be removed completely
    #   unless it's two internal nontouching spaces kitty corner from each other, then it's two separate corners
    # if there are 3 of a corner, it's a concave outside corner, and needs to be deduplicated
    # if there are 4 of a corner, it's an internal space and needs to be removed completely
    |> Enum.group_by(fn {corner_coord, _coord} -> corner_coord end)
    |> Enum.map(fn {corner_coord, list} ->
      frequency = length(list)

      case frequency do
        1 ->
          corner_coord

        2 ->
          # check to see if this is an internal space with a shared corner
          [{_, {row1, col1}}, {_, {row2, col2}}] = list

          if row1 == row2 || col1 == col2 do
            []
          else
            [corner_coord, corner_coord]
          end

        3 ->
          corner_coord

        4 ->
          []
      end
    end)
    |> List.flatten()
  end
end
