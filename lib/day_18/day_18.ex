defmodule AoC.Day18 do
  # Code pretty much copied from https://github.com/dallagi/aoc2021/blob/main/lib/aoc2021/day18.ex

  def get_input(file) do
    File.read!(Path.join(__DIR__, file))
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      {num, _} = Code.eval_string(line)
      num
    end)
  end

  def part1(input) do
    get_input(input)
    |> Enum.reduce(fn num, acc ->
      sum(acc, num)
    end)
    |> magnitude()
  end

  def magnitude([left, right]), do: 3 * magnitude(left) + 2 * magnitude(right)
  def magnitude(regular_number), do: regular_number

  def sum(num1, num2), do: reduce([reduce(num1), reduce(num2)])

  def reduce(number) do
    cond do
      path = to_explode(number) -> number |> explode(path) |> reduce()
      path = to_split(number) -> number |> split(path) |> reduce()
      true -> number
    end
  end

  def to_split(elem, path \\ []) do
    case elem do
      [left, right] -> to_split(left, [0 | path]) || to_split(right, [1 | path])
      elem when elem >= 10 -> Enum.reverse(path)
      _ -> nil
    end
  end

  def split(number, path) do
    update_in_list(number, path, fn elem -> [floor(elem / 2), ceil(elem / 2)] end)
  end

  def to_explode(number, path \\ [], depth \\ 0) do
    case number do
      [left, right] when depth == 4 and is_integer(left) and is_integer(right) ->
        Enum.reverse(path)

      [left, right] ->
        to_explode(left, [0 | path], depth + 1) || to_explode(right, [1 | path], depth + 1)

      _ ->
        nil
    end
  end

  def explode(number, path) do
    [num_left, num_right] = get_in_list(number, path)
    {{left_path, _left_elem}, {right_path, _right_elem}} = adjacent_elems(number, path)

    res = number
    res = if left_path == nil, do: res, else: update_in_list(res, left_path, &(&1 + num_left))
    res = if right_path == nil, do: res, else: update_in_list(res, right_path, &(&1 + num_right))

    update_in_list(res, path, fn _ -> 0 end)
  end

  def update_in_list(list, path, function) do
    accessor = for idx <- path, do: Access.at(idx)
    update_in(list, accessor, function)
  end

  def adjacent_elems(number, target_path) do
    paths = all_paths(number)

    target? = fn {path, _elem} -> List.starts_with?(path, target_path) end
    left_elem_idx = Enum.find_index(paths, target?) - 1
    right_elem_idx = find_last_index(paths, target?) + 1

    left = if left_elem_idx >= 0, do: Enum.at(paths, left_elem_idx)
    right = if right_elem_idx >= 0, do: Enum.at(paths, right_elem_idx)

    {left || {nil, nil}, right || {nil, nil}}
  end

  defp find_last_index(list, fun) do
    list
    |> Enum.with_index()
    |> Enum.reduce(nil, fn
      {elem, idx}, acc -> if fun.(elem), do: idx, else: acc
    end)
  end

  def all_paths(number) do
    number
    |> all_paths([])
    |> List.flatten()
  end

  def all_paths(elem, path_so_far) when is_integer(elem),
    do: {path_so_far |> Enum.reverse(), elem}

  def all_paths([left, right] = _pairs, path_so_far) do
    [all_paths(left, [0 | path_so_far]), all_paths(right, [1 | path_so_far])]
  end

  def get_in_list(list, path) do
    accessor = for idx <- path, do: Access.at(idx)
    get_in(list, accessor)
  end

  def part2(input) do
    numbers = get_input(input)

    for n1 <- numbers, n2 <- numbers do
      sum(n1, n2)
      |> magnitude()
    end
    |> Enum.max()
  end
end
