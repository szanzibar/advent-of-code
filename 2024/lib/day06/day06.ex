defmodule AoC2024.Day06 do
  @moduledoc """
  Part 1 wasn't a big deal, and I thought I had part 2 figured out reasonably quickly as well.
  However... No matter what I try I get the same wrong answer for part 2, an answer too low. (1577).

  I'll rubber duck in this journal entry.

  * Because the path is deterministic, and we can only INSERT ONE new obstacle,
      we MUST place the new obstacle somewhere on the path from part 1.
    * I verified that my obstacle possibilities are all on the path, excluding the start position
        The count of starting obstacles is = to part1 - 1.
  * I have 2 ways to determine infinite loops
    * High number of hitting the obstacle.
      * Maybe it's possible to have a valid path that hits the obstacle from multiple sides
      * But 5 times means that we MUST have hit the obstacle multiple times from the same direction,
          meaning infinite loop
    * Otherwise I'm determining infinite loops very naively, just breaking out if the number of loops gets really high.
      * I've done multiple tests and It seems like valid loops never go above 200 right turns
        * I guess it's possible there are some valid looooong loops somewhere that go longer than 1000,
            but none that go above 200? That's so evil if true.
          * I'll try some loooonger timeouts
          * Ok, even up to 100_000 right turns, my number comes out the same.
  * I've read over the instructions 5 times. I don't think I'm missing anything there.
  * I need to make sure it's not something dumb at this point. Like not counting breaking out of the loop sometimes
  * OHHHHHHHHHHHHHHH ok after printing out and spot checking graphs, I believe my problem is
      I'm not handling 2 right turns in a row 🤦
    * THAT FIXED IT

  LESSONS
  * Rubber ducking here helped. It allowed me to trust the parts that WERE logically sound,
  and move on to new places to look. Before making notes here I spent soooo much time
  fiddling around with breaking out of the infinite loops, coming up with complicated ideas
  for tracking loops, etc. But the naive approach I came up with in the first 5 seconds was
  ultimately fine.
  * Don't dwell too long on one thing. No tunnel vision.
  """

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, row_i} ->
      String.graphemes(row)
      |> Enum.with_index()
      |> Enum.map(fn {char, col_i} ->
        {{row_i, col_i}, char}
      end)
    end)
    |> Map.new()
  end

  @doc """
    iex> part1(AoC2024.Day06.Input.test_input())
    41

    iex> part1(AoC2024.Day06.Input.input())
    4602

  """
  def part1(input) do
    parse_input(input) |> move() |> Map.values() |> Enum.count(&(&1 == "X"))
  end

  defp move(map) do
    arrow =
      Enum.find(map, fn {_coord, space} ->
        space in ~w"^ > < v"
      end)

    move_one(map, arrow, 0)
  end

  # breakout from high number of right turns not hitting the obstacle
  defp move_one(_map, _, 200), do: :infinity
  defp move_one(_map, :infinity, _), do: :infinity
  defp move_one(map, nil, _), do: map

  defp move_one(map, {arrow_coord, arrow}, iteration) do
    {next_coord, _} = get_next_coord({arrow_coord, arrow})
    map = Map.put(map, arrow_coord, "X")

    Map.get(map, next_coord)
    |> case do
      nil ->
        # we move off the board
        move_one(map, nil, iteration)

      "#" ->
        # turn right
        right_turn = get_right_turn({arrow_coord, arrow})
        move_one(map, right_turn, iteration + 1)

      5 ->
        # After testing, breaking early by tracking obstacle hits doesn't save any time.
        # Must be infinite hitting the obstruction multiple times from the same direction
        move_one(map, :infinity, iteration)

      val when is_integer(val) ->
        # turn right and track hitting obstacle again
        map = Map.put(map, next_coord, val + 1)
        right_turn = get_right_turn({arrow_coord, arrow})
        move_one(map, right_turn, iteration + 1)

      val when val in [".", "X"] ->
        # keep going
        move_one(map, {next_coord, arrow}, iteration)
    end
  end

  defp get_next_coord({{row, col}, "^"}), do: {{row - 1, col}, "^"}
  defp get_next_coord({{row, col}, "v"}), do: {{row + 1, col}, "v"}
  defp get_next_coord({{row, col}, "<"}), do: {{row, col - 1}, "<"}
  defp get_next_coord({{row, col}, ">"}), do: {{row, col + 1}, ">"}

  defp get_right_turn({coord, "^"}), do: {coord, ">"}
  defp get_right_turn({coord, "v"}), do: {coord, "<"}
  defp get_right_turn({coord, "<"}), do: {coord, "^"}
  defp get_right_turn({coord, ">"}), do: {coord, "v"}

  # defp print_map(map) when is_map(map) do
  #   Enum.sort_by(map, fn {coord, _} -> coord end)
  #   |> Enum.chunk_by(fn {{row, _col}, _} -> row end)
  #   |> Enum.map(fn row ->
  #     row |> Enum.map(fn {_coord, value} -> value end) |> Enum.join(" ") |> IO.inspect()
  #   end)

  #   map
  # end

  # defp print_map(what), do: what

  @doc """
    iex> part2(AoC2024.Day06.Input.test_input())
    6

    iex> part2(AoC2024.Day06.Input.input())
    1703
    # > 1577

  """
  def part2(input) do
    map = parse_input(input)

    {start_coord, _} =
      Enum.find(map, fn {_coord, space} ->
        space in ~w"^ > < v"
      end)

    possible_obstruction_coords =
      map
      |> move()
      |> Enum.filter(fn {coord, value} -> value == "X" && coord != start_coord end)
      |> Enum.map(fn {coord, _} -> coord end)

    Enum.map(possible_obstruction_coords, fn coord ->
      Map.put(map, coord, 0) |> move()
    end)
    |> Enum.count(&(&1 == :infinity))
  end
end
