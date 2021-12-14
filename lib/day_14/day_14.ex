defmodule AoC.Day14 do
  def get_input(file) do
    [template, rules] =
      File.read!(Path.join(__DIR__, file))
      |> String.split("\n\n", trim: true)

    rules =
      rules
      |> String.split("\n")
      |> Enum.map(fn rule ->
        [k, v] = String.split(rule, " -> ", trim: true)

        graphemes = String.graphemes(k)
        first_letter = graphemes |> Enum.at(0)
        last_letter = graphemes |> Enum.at(-1)
        {k, [first_letter <> v, v <> last_letter]}
      end)
      |> Map.new()

    {template, rules}
  end

  def part1(input), do: day_14_common(input, 10)

  def part2(input), do: day_14_common(input, 40)

  defp day_14_common(input, steps) do
    {template, rules} = get_input(input)

    initial_template_counts(template)
    |> polymerize(rules, steps)
    |> get_element_counts()
    |> add_last_element_back(template)
    |> min_max_difference()
  end

  defp map_merge_add(map1, map2), do: Map.merge(map1, map2, fn _k, v1, v2 -> v1 + v2 end)

  defp initial_template_counts(template) do
    String.graphemes(template)
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(&Enum.join(&1))
    |> Enum.group_by(& &1)
    |> Enum.map(fn {k, v} ->
      {k, Enum.count(v)}
    end)
    |> Map.new()
  end

  defp polymerize(counts, _rules, 0), do: counts

  defp polymerize(counts, rules, max_steps) do
    Enum.map(counts, fn {k, count} ->
      [new_pair_1, new_pair_2] = rules[k]
      map_merge_add(%{new_pair_1 => count}, %{new_pair_2 => count})
    end)
    |> Enum.reduce(%{}, &map_merge_add(&1, &2))
    |> polymerize(rules, max_steps - 1)
  end

  def get_element_counts(counts) do
    Enum.map(counts, fn {k, v} ->
      first_letter = String.graphemes(k) |> Enum.at(0)
      %{first_letter => v}
    end)
    |> Enum.reduce(%{}, &map_merge_add(&1, &2))
  end

  defp add_last_element_back(counts, template) do
    last_letter = String.graphemes(template) |> Enum.at(-1)
    map_merge_add(counts, %{last_letter => 1})
  end

  defp min_max_difference(counts) do
    {min, max} =
      Enum.map(counts, fn {_k, v} -> v end)
      |> Enum.min_max()

    max - min
  end
end
