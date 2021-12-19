defmodule AoC.Day15 do
  import Graph
  alias Graph.Edge

  def get_input(file) do
    lines =
      File.read!(Path.join(__DIR__, file))
      |> String.split("\n", trim: true)

    height = Enum.count(lines) - 1
    width = String.length(Enum.at(lines, 0)) - 1

    grid =
      Enum.map(
        lines,
        &(String.graphemes(&1)
          |> Enum.map(fn s -> String.to_integer(s) end)
          |> Enum.with_index())
      )
      |> Enum.with_index()
      |> Enum.flat_map(fn {row, x} ->
        Enum.map(row, fn {num, y} ->
          %{[x, y] => num}
        end)
      end)
      |> Enum.reduce(%{}, &Map.merge(&1, &2))

    {grid, [height, width]}
  end

  def part1(input) do
    {grid, destination} = get_input(input)
    path = grid |> build_graph() |> dijkstra([0, 0], destination)

    Enum.reduce(path, 0, &(grid[&1] + &2)) - grid[[0, 0]]
  end

  def part2(input) do
    # requires modification to libgraph. See https://github.com/bitwalker/libgraph/issues/44#issue-1080709977
    modifiers =
      for x <- 0..4, y <- 0..4 do
        [x, y]
      end

    {grid, [x_dest, y_dest]} = get_input(input)

    destination = [(x_dest + 1) * 5 - 1, (y_dest + 1) * 5 - 1]

    grid =
      Enum.flat_map(modifiers, fn [x_mod, y_mod] ->
        x_plus = (x_dest + 1) * x_mod
        y_plus = (y_dest + 1) * y_mod

        Enum.map(grid, fn {[x, y], _risk} ->
          {[x + x_plus, y + y_plus], modified_risk(grid[[x, y]], [x_mod, y_mod])}
        end)
      end)
      |> Map.new()

    [x_goal, y_goal] = destination

    heuristic = fn [x, y] ->
      dx = abs(x - x_goal)
      dy = abs(y - y_goal)
      dx + dy
    end

    path =
      grid
      |> build_graph()
      |> a_star([0, 0], destination, heuristic)

    Enum.reduce(path, 0, &(grid[&1] + &2)) - grid[[0, 0]]
  end

  defp build_graph(grid) do
    edges =
      Enum.flat_map(grid, fn {[x, y], weight} ->
        neighbors = Map.take(grid, [[x, y + 1], [x + 1, y], [x, y - 1], [x - 1, y]])

        Enum.map(neighbors, fn {[x_n, y_n], _weight_n} ->
          Edge.new([x_n, y_n], [x, y], weight: weight)
        end)
      end)

    Graph.new() |> Graph.add_edges(edges)
  end

  defp modified_risk(risk_level, [x, y]) do
    modifier = x + y
    incremented_risk = risk_level + modifier

    case incremented_risk <= 9 do
      true -> incremented_risk
      false -> incremented_risk - 9
    end
  end
end
