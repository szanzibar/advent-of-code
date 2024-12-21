defmodule AoC2024.Day16 do
  alias Graph.Edge
  # import Utils

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, row_index} ->
      line
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.map(fn {char, col_index} ->
        {{row_index, col_index}, char}
      end)
    end)
  end

  defp build_graph(coords) do
    moveable = Enum.reject(coords, fn {_coord, char} -> char == "#" end)
    graph = Graph.new()

    edges =
      Enum.flat_map(moveable, fn {coord, char} ->
        next_coords(coord)
        |> Enum.map(fn next_coord ->
          Enum.find(moveable, fn {coord, _char} -> coord == next_coord end)
        end)
        |> Enum.reject(&is_nil/1)
        |> Enum.map(fn {next_coord, _} -> next_coord end)
        |> case do
          next_coords when char == "E" ->
            Enum.map(next_coords, fn next_coord ->
              Edge.new(coord, next_coord)
            end)

          next_coords when char == "S" ->
            {s_row, _s_col} = coord

            Enum.map(next_coords, fn {next_row, _} = next_coord ->
              if next_row == s_row do
                Edge.new(coord, next_coord)
              else
                Edge.new(coord, next_coord, weight: 1001)
              end
            end)

          [one] ->
            [Edge.new(coord, one)]

          [{row1, col1} = one, {row2, col2} = two] ->
            if row1 == row2 or col1 == col2 do
              # straight line
              [Edge.new(coord, one), Edge.new(coord, two)]
            else
              # turn
              [Edge.new(two, one, weight: 1002), Edge.new(one, two, weight: 1002)]
            end

          [one, two, three] ->
            combos = [[one, two], [one, three], [two, three]]

            Enum.concat(combos, Enum.map(combos, &Enum.reverse/1))
            |> Enum.map(fn [one, two] ->
              Edge.new(one, two, weight: weigh_pair(one, two) + 1)
            end)

          [one, two, three, four] ->
            combos = [
              [one, two],
              [one, three],
              [one, four],
              [two, three],
              [two, four],
              [three, four]
            ]

            Enum.concat(combos, Enum.map(combos, &Enum.reverse/1))
            |> Enum.map(fn [one, two] ->
              Edge.new(one, two, weight: weigh_pair(one, two) + 1)
            end)
        end
      end)

    Graph.add_edges(graph, edges)
  end

  @doc """
    iex> part1(AoC2024.Day16.Input.test_input())
    7036

    iex> part1(AoC2024.Day16.Input.test_input2())
    11048

    iex> part1(AoC2024.Day16.Input.input())
    102504

  """
  def part1(input) do
    map = parse_input(input)
    graph = build_graph(map)
    IO.inspect("built graph: #{inspect(graph)}")
    # dump_to_file(Graph.edges(graph))

    {start, finish} = get_start_finish(map)
    shortest_path = Graph.dijkstra(graph, start, finish)
    # all_paths = Graph.get_paths(graph, start, finish)
    # IO.inspect("Got all #{length(all_paths)} paths")

    # weighed_paths = weigh_paths(all_paths)

    # Enum.min(weighed_paths)
    weigh_path(graph, shortest_path)
  end

  defp weigh_path(graph, path) do
    Enum.chunk_every(path, 2, 1, :discard)
    |> Enum.map(fn [v1, v2] ->
      Graph.edge(graph, v1, v2).weight
    end)
    |> Enum.sum()
  end

  defp weigh_pair({row1, col1}, {row2, col2}) do
    if row1 != row2 && col1 != col2 do
      1001
    else
      1
    end
  end

  defp get_start_finish(map) do
    {start, _char} = Enum.find(map, fn {_coord, char} -> char == "S" end)
    {finish, _char} = Enum.find(map, fn {_coord, char} -> char == "E" end)
    {start, finish}
  end

  defp next_coords({row, col}) do
    [{-1, 0}, {0, 1}, {1, 0}, {0, -1}]
    |> Enum.map(fn {row_offset, col_offset} ->
      {row_offset + row, col_offset + col}
    end)
  end

  @doc """
    # iex> part2(AoC2024.Day16.Input.test_input())
    # nil

    # iex> part2(AoC2024.Day16.Input.input())
    # nil

  """
  def part2(input) do
    parse_input(input)
  end
end
