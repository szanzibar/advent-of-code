defmodule AoC2024.Day11 do
  @moduledoc """
  I don't know how crazy this idea was, but it worked super well.

  I did part 1 the straightforward way, which of course did not scale to 75 times

  For part 2, I figured that if I had a cheat sheet for each single digit, it would make the majority
  of calculations instant, and it should be somewhat easy to generate cheat sheets.

  Except even starting with a single digit, around 40-45 it got unbearably slow.

  So I made cheatsheets up to 40, then used those cheatsheets to go up to 60,
  and so on until making cheatsheets up to 75 was instant.

  Part 2 now takes about ~2 seconds!
  """

  require Integer
  import Utils
  import Day11.AnswerMap

  def parse_input(input) do
    input |> String.trim() |> String.split(" ") |> Enum.map(&String.to_integer/1)
  end

  @doc """
    iex> part1(AoC2024.Day11.Input.test_input())
    55312

    iex> part1(AoC2024.Day11.Input.input())
    193899

  """
  def part1(input) do
    parse_input(input) |> calculate(25)
  end

  defp blink(number, 0), do: number

  defp blink(number, count) when is_list(number) do
    Enum.map(number, &blink(&1, count))
  end

  # Don't forget to update this guard to be the max
  # from the generated answer cheat sheet
  defp blink(number, count) when number < 10 and count <= 75 do
    {:count, get_in(answer_map()[number][count])}
  end

  defp blink(number, count) do
    digits = Integer.digits(number)
    digit_length = length(digits)

    if Integer.is_even(digit_length) do
      half = Integer.floor_div(digit_length, 2)

      chunks =
        Enum.chunk_every(digits, half)
        |> Enum.map(&Integer.undigits/1)

      blink(chunks, count - 1)
    else
      blink(2024 * number, count - 1)
    end
  end

  @doc """
    iex> part2(AoC2024.Day11.Input.input())
    229682160383225

  """
  def part2(input) do
    parse_input(input) |> calculate(75)
  end

  defp calculate(numbers, count) do
    {sums, list} =
      numbers
      |> Enum.map(&blink(&1, count))
      |> List.flatten()
      |> Enum.split_with(fn element ->
        match?({:count, _}, element)
      end)

    Enum.reduce(sums, 0, fn {:count, sum}, acc -> sum + acc end) + Enum.count(list)
  end

  @doc """
  # iex> generate_answer_maps()
  # :ok

  """
  def generate_answer_maps() do
    max = 75

    dump_to_file("defmodule Day11.AnswerMap do")
    dump_to_file("@answer_map %{")

    Enum.map(
      0..9,
      fn integer ->
        dump_to_file("#{integer} => %{")

        Range.new(0, max)
        |> Enum.map(fn count ->
          result = calculate([integer], count)
          dump_to_file("#{count} => #{result},")
        end)

        dump_to_file("},")
      end
    )

    dump_to_file("}")
    dump_to_file("def answer_map, do: @answer_map")
    dump_to_file("end")

    :ok
  end
end
