defmodule AoC2024.Day03 do
  @moduledoc """
  Shout out to @cfbender for encouraging me to keep an AoC journal so here goes:

  Super easy regex for part 1 imo. Although, I don't know lookaheads & lookbehinds very well,
  so I decided to do part 2 with a recursive function.
  I think that was the right call as it went quite quickly.

  I even initially made parse_sections() functions that discarded multiple do()|don't() in a row,
  but that never ended up occurring in my data so I took it back out for brevity.
  """

  def parse_input(input) do
    input |> String.trim()
  end

  @doc """
    iex> part1(AoC2024.Day03.Input.test_input())
    161

    iex> part1(AoC2024.Day03.Input.input())
    185797128

  """
  def part1(input) do
    parse_input(input) |> parse()
  end

  @doc """
    iex> part2(AoC2024.Day03.Input.test_input_part_2())
    48

    iex> part2(AoC2024.Day03.Input.input())
    89798695

  """
  def part2(input) do
    ~r/(do\(\))|(don't\(\))/
    |> Regex.split(parse_input(input), include_captures: true)
    |> parse_sections()
  end

  def parse_sections(instructions, acc \\ 0)
  def parse_sections([], acc), do: acc
  def parse_sections([hd | rest], 0), do: parse_sections(rest, parse(hd))
  def parse_sections(["do()", do_it | rest], acc), do: parse_sections(rest, parse(do_it) + acc)
  def parse_sections(["don't()", _just_dont | rest], acc), do: parse_sections(rest, acc)

  def parse(string) do
    regex = ~r/mul\((\d{1,3}),(\d{1,3})\)/

    Regex.scan(regex, string, capture: :all_but_first)
    |> Enum.map(fn [l, r] ->
      String.to_integer(l) * String.to_integer(r)
    end)
    |> Enum.sum()
  end
end
