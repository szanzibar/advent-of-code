defmodule AoC2023.Day10 do
  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, row} ->
      line
      |> String.codepoints()
      |> Enum.with_index()
      |> Enum.filter(fn {char, _} -> char != "." end)
      |> Enum.map(fn {char, col} ->
        key = {row, col}

        value =
          case char do
            # Just getting the start directions with my eyes
            # all examples have S start with {:right, :down}, but that's arbitrary

            # Initially I thought I would track distance in the third tuple spot,
            # but the farthest point from start of a loop is just length/2
            # can't be bothered to refactor the data structure
            "S" -> {:right, :down, 0}
            "|" -> {:up, :down, nil}
            "-" -> {:left, :right, nil}
            "L" -> {:up, :right, nil}
            "J" -> {:up, :left, nil}
            "7" -> {:left, :down, nil}
            "F" -> {:right, :down, nil}
          end

        {key, value}
      end)
    end)
    |> Map.new()
  end

  @doc """
    iex> part1(AoC2023.Day10.Input.test_input())
    8

    iex> part1(AoC2023.Day10.Input.test_input_2())
    4

    iex> part1(AoC2023.Day10.Input.input())
    6838

  """
  def part1(input) do
    map = parse_input(input)

    {_, {dir1, _, _}} = start = get_start(map)

    params =
      %{
        path: [start],
        from_dir: dir1,
        start: start,
        map: map
      }

    path = build_path(params)

    Enum.count(path) |> Integer.floor_div(2)
  end

  def build_path(%{path: [next | path_tail], start: start})
      when start == next and length(path_tail) > 1,
      do: path_tail

  def build_path(
        %{
          path: [{coord, {dir1, dir2, _distance}} | _] = path,
          from_dir: from_dir,
          map: map
        } = params
      ) do
    {next_dir, next_coord} = get_next_coord(dir1, dir2, from_dir, coord)
    next_node = Map.get(map, next_coord)

    build_path(%{
      params
      | path: [{next_coord, next_node} | path],
        from_dir: opposite_dir(next_dir)
    })
  end

  def get_next_coord(dir1, dir2, from_dir, {row, col}) do
    [dir1, dir2]
    |> Enum.reject(&(&1 == from_dir))
    |> case do
      [:left] -> {:left, {row, col - 1}}
      [:up] -> {:up, {row - 1, col}}
      [:right] -> {:right, {row, col + 1}}
      [:down] -> {:down, {row + 1, col}}
    end
  end

  defp get_start(map) do
    map
    |> Enum.find(fn
      {_, {_, _, 0}} -> true
      _ -> false
    end)
  end

  defp opposite_dir(:left), do: :right
  defp opposite_dir(:right), do: :left
  defp opposite_dir(:up), do: :down
  defp opposite_dir(:down), do: :up

  @doc """
    iex> part2(AoC2023.Day10.Input.test_input_2())
    1

    iex> part2(AoC2023.Day10.Input.test_part_2_input())
    4

    iex> part2(AoC2023.Day10.Input.test_part_2_input_2())
    4

    iex> part2(AoC2023.Day10.Input.input())
    451

  """
  def part2(input) do
    map = parse_input(input)

    {_, {dir1, _, _}} = start = get_start(map)

    params =
      %{
        path: [start],
        from_dir: dir1,
        start: start,
        map: map
      }

    path = build_path(params)

    left_right_params = %{
      path: path |> Enum.reverse(),
      from_dir: dir1,
      start: start,
      map: Map.new(path)
    }

    left_right_map = build_left_right(left_right_params)

    size = left_right_map |> map_size()

    inside_letter = get_inside_letter(left_right_map)

    expanded = e_x_p_a_n_d(left_right_map, {nil, size}, inside_letter)

    Enum.filter(expanded, fn {_, value} -> value == inside_letter end) |> Enum.count()
  end

  def get_inside_letter(map) do
    Enum.find_value(map, fn
      {_, {_, _, _}} -> false
      {{0, _}, value} -> value
      {{_, 0}, value} -> value
      _ -> false
    end)
    |> case do
      "R" -> "L"
      "L" -> "R"
    end
  end

  def e_x_p_a_n_d(map, {count, new_count}, _) when count == new_count, do: map

  def e_x_p_a_n_d(map, {_, count}, letter) do
    left_rights = Enum.filter(map, fn {_, value} -> value == letter end)
    expanded_map = expand_space(left_rights, map, letter)
    new_count = expanded_map |> Enum.count()

    e_x_p_a_n_d(expanded_map, {count, new_count}, letter)
  end

  def expand_space([], map, _), do: map

  def expand_space([{{row, col}, _} | left_rights], map, letter) do
    expanded_map =
      [
        {row, col - 1},
        {row - 1, col - 1},
        {row - 1, col},
        {row - 1, col + 1},
        {row, col + 1},
        {row + 1, col + 1},
        {row + 1, col},
        {row + 1, col - 1}
      ]
      |> Enum.reduce(map, fn coord, map_acc ->
        Map.put_new(map_acc, coord, letter)
      end)

    expand_space(left_rights, expanded_map, letter)
  end

  def build_left_right(%{path: [], map: map}), do: map

  def build_left_right(
        %{
          path: [{coord, {dir1, dir2, _distance}} | path_tail],
          from_dir: from_dir,
          map: map
        } = params
      ) do
    {next_dir, _next_coord} = get_next_coord(dir1, dir2, from_dir, coord)

    marked_map = map |> mark_left_right(coord, from_dir, next_dir)

    build_left_right(%{
      params
      | path: path_tail,
        from_dir: opposite_dir(next_dir),
        map: marked_map
    })
  end

  def mark_left_right(map, {row, col}, from_dir, next_dir) do
    w = {row, col - 1}
    nw = {row - 1, col - 1}
    n = {row - 1, col}
    ne = {row - 1, col + 1}
    e = {row, col + 1}
    se = {row + 1, col + 1}
    s = {row + 1, col}
    sw = {row + 1, col - 1}

    neighbors =
      case {from_dir, next_dir} do
        {:right, :left} -> %{right: [n], left: [s]}
        {:left, :right} -> %{right: [s], left: [n]}
        {:up, :down} -> %{right: [w], left: [e]}
        {:down, :up} -> %{right: [e], left: [w]}
        {:right, :down} -> %{right: [n, nw, w], left: []}
        {:down, :right} -> %{right: [], left: [n, nw, w]}
        {:up, :right} -> %{right: [w, sw, s], left: []}
        {:right, :up} -> %{right: [], left: [w, sw, s]}
        {:left, :up} -> %{right: [s, se, e], left: []}
        {:up, :left} -> %{right: [], left: [s, se, e]}
        {:left, :down} -> %{right: [], left: [n, ne, e]}
        {:down, :left} -> %{right: [n, ne, e], left: []}
      end

    right_map =
      neighbors.right
      |> Enum.reduce(map, fn coord, acc_map ->
        Map.put_new(acc_map, coord, "R")
      end)

    left_right_map =
      neighbors.left
      |> Enum.reduce(right_map, fn coord, acc_map ->
        Map.put_new(acc_map, coord, "L")
      end)

    left_right_map
  end
end
