defmodule AoC.Day12 do
  def get_input(file) do
    File.read!(Path.join(__DIR__, file))
    |> String.split("\n", trim: true)
    |> Enum.flat_map(fn x ->
      [a, b] = String.split(x, "-", trim: true)
      [[a, b], [b, a]]
    end)
    |> Enum.filter(fn [last, first] ->
      last != "start" && first != "end"
    end)
  end

  def part1(input) do
    cave_pairs = get_input(input)

    start = Enum.filter(cave_pairs, fn [_back, front] -> front == "start" end)

    filter = fn list, path -> valid_next_cave_part_1(list, path) end

    next_cave(start, cave_pairs, false, filter) |> Enum.count()
  end

  defp next_cave(current_paths, _, true, _) do
    current_paths |> Enum.filter(&(hd(&1) == "end"))
  end

  defp next_cave(current_paths, cave_pairs, _finished, filter) do
    new_paths =
      Enum.flat_map(current_paths, fn path ->
        next_caves =
          Enum.filter(cave_pairs, fn [back, front] ->
            front == hd(path) && filter.(back, path)
          end)

        case next_caves do
          [] -> [path]
          _ -> Enum.map(next_caves, fn [back, _front] -> [back | path] end)
        end
      end)

    next_cave(new_paths, cave_pairs, Enum.count(new_paths) == Enum.count(current_paths), filter)
  end

  defp valid_next_cave_part_1(cave, path) do
    is_uppercase(cave) || !Enum.member?(path, cave)
  end

  defp valid_next_cave(cave, path) do
    case valid_next_cave_part_1(cave, path) do
      true ->
        true

      false ->
        case already_visited_small_cave(path) do
          true -> false
          false -> Enum.count(path, &(&1 == cave)) <= 1
        end
    end
  end

  defp is_uppercase(string), do: String.upcase(string) == string

  defp already_visited_small_cave(path) do
    lower_case_filtered = Enum.filter(path, &(&1 != "start" && &1 != "end" && !is_uppercase(&1)))

    Enum.uniq(lower_case_filtered) != lower_case_filtered
  end

  def part2(input) do
    cave_pairs = get_input(input)
    start = Enum.filter(cave_pairs, fn [_back, front] -> front == "start" end)
    filter = fn list, path -> valid_next_cave(list, path) end

    next_cave(start, cave_pairs, 0, filter) |> Enum.count()
  end
end
