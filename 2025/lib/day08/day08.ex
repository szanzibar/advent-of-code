defmodule AoC2025.Day08 do
  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn line ->
      [x, y, z] = String.split(line, ",", trim: true) |> Enum.map(&String.to_integer/1)
      {x, y, z}
    end)
  end

  @doc """
    iex> part1(AoC2025.Day08.Input.test_input(), 10)
    40

    iex> part1(AoC2025.Day08.Input.input(), 1000)
    66640

  """
  def part1(input, pair_count) do
    coordinates = parse_input(input)

    distances_with_coords =
      coordinates
      |> calculate_distances
      |> Enum.sort_by(fn {_coord_pair, distance} -> distance end)
      |> Enum.take(pair_count)

    shortest_coord_pairs =
      Enum.map(distances_with_coords, fn {coord_pair, _distance} -> coord_pair end)

    joined_circuits =
      join_circuits(coordinates, shortest_coord_pairs)
      |> Enum.sort_by(&length/1, :desc)

    top_3_lengths = Enum.take(joined_circuits, 3) |> Enum.map(&length/1)

    Enum.product(top_3_lengths)
  end

  defp join_circuits(coordinates, coord_pairs, opts \\ []) do
    just_last_pair? = Keyword.get(opts, :just_last_pair?, false)

    circuits = coordinates |> Enum.map(&[&1])

    # need to loop through coord_pairs, and combine the two circuits that contain those two coords in the pair
    Enum.reduce_while(coord_pairs, circuits, fn [coord1, coord2], circuits_acc ->
      {to_combine, unchanged_circuits} =
        Enum.split_with(circuits_acc, fn circuit ->
          # circuit is a list of coords in a circuit
          coord1 in circuit || coord2 in circuit
        end)

      combined = Enum.concat(to_combine)

      if just_last_pair? && unchanged_circuits == [] do
        {:halt, {coord1, coord2}}
      else
        {:cont, [combined | unchanged_circuits]}
      end
    end)
  end

  defp calculate_distances(coords, distances \\ [])
  defp calculate_distances([], distances), do: distances

  defp calculate_distances([hd | tl], distances) do
    # need to calculate the distance between this head and the rest of the tail

    new_distances =
      tl
      |> Enum.map(fn tail_coord ->
        distance = calculate_distance(hd, tail_coord)
        {Enum.sort([hd, tail_coord]), distance}
      end)

    calculate_distances(tl, distances ++ new_distances)
  end

  defp calculate_distance({x1, y1, z1}, {x2, y2, z2}) do
    x = Integer.pow(x1 - x2, 2) / 1
    y = Integer.pow(y1 - y2, 2) / 1
    z = Integer.pow(z1 - z2, 2) / 1
    Float.pow(x + y + z, 1 / 2)
  end

  @doc """
    iex> part2(AoC2025.Day08.Input.test_input())
    25272

    iex> part2(AoC2025.Day08.Input.input())
    78894156

  """
  def part2(input) do
    coordinates = parse_input(input)

    distances_with_coords =
      coordinates
      |> calculate_distances
      |> Enum.sort_by(fn {_coord_pair, distance} -> distance end)

    shortest_coord_pairs =
      Enum.map(distances_with_coords, fn {coord_pair, _distance} -> coord_pair end)

    {{x1, _y1, _z1}, {x2, _y2, _z2}} =
      join_circuits(coordinates, shortest_coord_pairs, just_last_pair?: true)

    x1 * x2
  end
end
