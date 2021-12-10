defmodule AoC.Day10 do
  @char_map %{
    "(" => ")",
    "[" => "]",
    "{" => "}",
    "<" => ">"
  }
  @points %{
    ")" => 3,
    "]" => 57,
    "}" => 1197,
    ">" => 25_137
  }
  @p2points %{
    ")" => 1,
    "]" => 2,
    "}" => 3,
    ">" => 4
  }

  defp get_input(file) do
    File.read!(Path.join(__DIR__, file))
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes(&1))
  end

  def part1(input) do
    get_input(input)
    |> Enum.map(&parse(&1, []))
    |> Enum.filter(&is_number(&1))
    |> Enum.sum()
  end

  defp parse([], closing_list), do: closing_list

  defp parse([head | tail], closing_list) do
    cond do
      Enum.member?(Map.keys(@char_map), head) ->
        parse(tail, [@char_map[head] | closing_list])

      head == hd(closing_list) ->
        parse(tail, tl(closing_list))

      true ->
        @points[head]
    end
  end

  def part2(input) do
    completions =
      get_input(input)
      |> Enum.map(&parse(&1, []))
      |> Enum.filter(&(!is_number(&1)))

    Enum.map(completions, fn line ->
      Enum.reduce(line, 0, fn char, acc ->
        acc * 5 + @p2points[char]
      end)
    end)
    |> Enum.sort()
    |> Enum.at(Enum.count(completions) |> Integer.floor_div(2))
  end
end
