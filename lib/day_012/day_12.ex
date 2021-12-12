defmodule AoC.Day12 do
  def get_input(file) do
    list =
      File.read!(Path.join(__DIR__, file))
      |> String.split("\n", trim: true)
      |> Enum.flat_map(fn x ->
        [a, b] = String.split(x, "-", trim: true)
        [[a, b], [b, a]]
      end)

    remove =
      Enum.filter(list, fn [a, b] ->
        a == "start" || b == "end"
      end)

    list -- remove
  end

  def part1(input) do
    pairs = get_input(input)

    start = Enum.filter(pairs, fn [_back, front] -> front == "start" end)

    filter = fn list, path -> valid_next_pair_part_1(list, path) end

    next_cave(start, pairs, false, filter) |> Enum.count()
  end

  defp next_cave(current_paths, _, true, _) do
    current_paths |> Enum.filter(&(hd(&1) == "end"))
  end

  defp next_cave(current_paths, pairs, _finished, filter) do
    new_paths =
      Enum.flat_map(current_paths, fn path ->
        next_caves = Enum.filter(pairs, fn pair -> filter.(pair, path) end)

        case next_caves do
          [] -> [path]
          _ -> Enum.map(next_caves, fn [back, _front] -> [back | path] end)
        end
      end)

    next_cave(new_paths, pairs, Enum.count(new_paths) == Enum.count(current_paths), filter)
  end

  defp valid_next_pair_part_1([back, front], path) do
    front == hd(path) && (is_uppercase(back) || !Enum.member?(path, back))
  end

  defp valid_next_pair([back, front], path) do
    cond do
      front != hd(path) || hd(path) == "end" || hd(path) == "start" ->
        false

      is_uppercase(back) || !Enum.member?(path, back) ->
        true

      true ->
        lower_case_filtered =
          Enum.filter(path, &(&1 != "start" && &1 != "end" && !is_uppercase(&1)))

        already_visited_small_cave = Enum.uniq(lower_case_filtered) != lower_case_filtered

        case already_visited_small_cave do
          true ->
            valid_next_pair_part_1([back, front], path)

          false ->
            Enum.count(path, fn cave -> cave == back end) <= 1
        end
    end
  end

  defp is_uppercase(string), do: String.upcase(string) == string

  def part2(input) do
    pairs = get_input(input)
    start = Enum.filter(pairs, fn [_back, front] -> front == "start" end)
    filter = fn list, path -> valid_next_pair(list, path) end

    next_cave(start, pairs, 0, filter) |> Enum.count()
  end
end
