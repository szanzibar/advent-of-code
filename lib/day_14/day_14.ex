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

        first_letter = String.graphemes(k) |> Enum.at(0)
        {k, first_letter <> v}
      end)
      |> Map.new()

    template_last_letter = String.graphemes(template) |> Enum.at(-1)
    rules = Map.put(rules, template_last_letter, template_last_letter)

    {template, rules}
  end

  def part1(input) do
    {template, rules} = get_input(input)

    polymerize(template, rules, 10)
    |> min_max_difference()
  end

  defp min_max_difference(template) do
    {min, max} =
      template
      |> String.graphemes()
      |> Enum.group_by(& &1)
      |> Enum.map(fn {_k, v} ->
        Enum.count(v)
      end)
      |> Enum.min_max()

    max - min
  end

  defp polymerize(template, _rules, 0), do: template

  defp polymerize(template, rules, max_steps) do
    max_steps |> IO.inspect(label: "steps left")

    String.graphemes(template)
    |> Enum.chunk_every(2, 1)
    |> Enum.map(&Enum.join(&1))
    |> Enum.map_join(fn chunk ->
      rules[chunk]
    end)
    |> IO.inspect(label: "template")
    |> polymerize(rules, max_steps - 1)
  end

  def part2(input) do
    {template, rules} = get_input(input)

    polymerize(template, rules, 40)
    |> min_max_difference()
  end
end
