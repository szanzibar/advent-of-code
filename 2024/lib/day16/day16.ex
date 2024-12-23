defmodule AoC2024.Day16 do
  @moduledoc """
  LOLLLLLLLLLLL I genuinely cannot believe my hacky shitty idea actually worked for part 2.

  Part 1 was easy enough after I relearned the libgraph library and got my build_graph function built.

  Part 2 took a ton of hacky shitty tries. I _really_ didn't feel up to writing my own
  dijkstra implementation, but in the end it probably wouldn't have been much longer.

  libgraph is just unable to run get_paths in a reasonable amount of time. The smallest first example
  still took 20 seconds.

  libgraph also has no way to find multiple paths as far as I could figure, only the shortest path.

  So this is what I did instead:
  After I found the fastest path, I looped through each vertex in the path, deleted it from the graph,
    and found the fastest path again with that vertex missing.
  Collected all the paths that still had the fastest score, and repeated that process above for each of _those_ paths
  This ended up being a ton of loops, but it seemed to be a manageable number. Basically instant with the 2 examples.
  The one wrinkle with this is it would still not use some paths. I managed to finally fix this by
  using a* instead of dijkstra. I would decrease the cost to take a vertex that hadn't been used before.
  (I tried tweaking the a* heuristic function to avoid looping and deleting one vertex at a time but I couldn't get it to work)

  This implementation worked instantly for both examples.

  The last problem was performance. For the full input, it was extremely slow. By breaking things into chunks and
  async tasks, I managed to get part 2 in around 5 minutes.

  I was literally about to give up if this last result wasn't the answer. I swear a hacky hail mary never
  pans out in AoC. Christmas came early this year.
  """
  alias Graph.Edge

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
              # Put the coord that we skipped in the label to count traveled paths later
              [
                Edge.new(two, one, label: coord, weight: 1002),
                Edge.new(one, two, label: coord, weight: 1002)
              ]
            end

          [one, two, three] ->
            combos = [[one, two], [one, three], [two, three]]

            Enum.concat(combos, Enum.map(combos, &Enum.reverse/1))
            |> Enum.map(fn [one, two] ->
              # Put the coord that we skipped in the label to count traveled paths later
              Edge.new(one, two, label: coord, weight: weigh_pair(one, two) + 1)
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
              # Put the coord that we skipped in the label to count traveled paths later
              Edge.new(one, two, label: coord, weight: weigh_pair(one, two) + 1)
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
    IO.inspect("building graph")
    graph = build_graph(map)
    IO.inspect("done building graph")

    {start, finish} = get_start_finish(map)
    shortest_path = Graph.dijkstra(graph, start, finish)
    IO.inspect("done finding path")

    weigh_path(graph, shortest_path)
  end

  defp weigh_path(graph, path) do
    Enum.chunk_every(path, 2, 1, :discard)
    |> Enum.map(fn [v1, v2] ->
      [edge] = Graph.edges(graph, v1, v2)
      edge.weight
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

  defp path_to_edges(graph, path) do
    Enum.chunk_every(path, 2, 1, :discard)
    |> Enum.map(fn [v1, v2] ->
      [edge] = Graph.edges(graph, v1, v2)
      edge
    end)
  end

  defp edges_to_vertices(edges) do
    Enum.flat_map(edges, fn edge ->
      if is_nil(edge.label) do
        [edge.v1, edge.v2]
      else
        [edge.v1, edge.v2, edge.label]
      end
    end)
    |> Enum.uniq()
  end

  defp path_to_vertices(graph, path) do
    path_to_edges(graph, path) |> edges_to_vertices()
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
    iex> part2(AoC2024.Day16.Input.test_input())
    45

    iex> part2(AoC2024.Day16.Input.test_input2())
    64

    iex> part2(AoC2024.Day16.Input.input())
    535

  """
  def part2(input) do
    map = parse_input(input)
    IO.inspect("building graph")
    graph = build_graph(map)
    IO.inspect("done building graph")

    {start, finish} = get_start_finish(map)
    shortest_path = Graph.dijkstra(graph, start, finish)
    IO.inspect("done finding path")

    other_paths = get_even_more_paths(shortest_path, graph, start, finish)

    Enum.concat(other_paths, [shortest_path])
    |> Enum.flat_map(fn path -> path_to_vertices(graph, path) end)
    |> Enum.uniq()
    |> Enum.count()
  end

  defp get_even_more_paths(path, graph, start, finish) do
    other_paths = get_more_paths(path, graph, start, finish)
    IO.inspect("done finding more paths. there were #{length(other_paths)}")

    even_more_paths =
      other_paths
      |> Enum.chunk_every(6)
      |> Enum.with_index()
      |> Enum.flat_map(fn {chunk, index} ->
        result =
          chunk
          |> Enum.with_index()
          |> Enum.map(fn {path, path_index} ->
            Task.async(fn ->
              IO.inspect("starting chunk #{index}, path #{path_index}")
              result = get_more_paths(path, graph, start, finish)
              result_fn = fn -> result end

              IO.inspect("finished chunk #{index}, path #{path_index}")
              result_fn
            end)
          end)
          |> Task.await_many(:infinity)

        result
      end)
      |> Enum.flat_map(fn result -> result.() end)

    IO.inspect("done finding even MOAR paths")
    other_paths ++ even_more_paths
  end

  defp get_more_paths(path, graph, start, finish) do
    weight = weigh_path(graph, path)

    Enum.map(path, fn vertex ->
      Task.async(fn ->
        Graph.delete_vertex(graph, vertex)
        |> Graph.a_star(start, finish, fn v ->
          if v in path, do: -1005, else: 0
        end)
      end)
    end)
    |> Task.await_many(:infinity)
    |> Enum.reject(&is_nil/1)
    |> Enum.filter(fn path ->
      weigh_path(graph, path) == weight
    end)
  end
end
