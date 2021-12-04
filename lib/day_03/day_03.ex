defmodule AoC.Day03 do
  defp get_input(file) do
    File.read!(Path.join(__DIR__, file))
    |> String.split("\n", trim: true)
    |> Enum.map(
      &(String.codepoints(&1)
        |> Enum.map(fn s -> String.to_integer(s) end))
    )
  end

  def part1(input) do
    input = get_input(input)
    length = Enum.count(input)

    totals =
      input
      |> Enum.zip()
      |> Enum.map(&Tuple.sum(&1))

    gamma = Enum.map(totals, fn digit -> if length - digit < length / 2, do: 1, else: 0 end)

    epsilon = Enum.map(gamma, fn digit -> Bitwise.bxor(digit, 1) end)

    Integer.undigits(epsilon, 2) * Integer.undigits(gamma, 2)
  end

  def part2(input) do
    input = get_input(input)

    oxygen_filter = fn one_count, length -> if one_count >= length / 2, do: 1, else: 0 end
    scrubber_filter = fn one_count, length -> if one_count < length / 2, do: 1, else: 0 end

    oxygen = filter(input, 0, oxygen_filter) |> Integer.undigits(2)
    scrubber = filter(input, 0, scrubber_filter) |> Integer.undigits(2)

    oxygen * scrubber
  end

  defp filter([last | []], _digit, _func), do: last

  defp filter(list, current_digit, func) do
    length = Enum.count(list)

    one_count =
      Enum.map(list, fn number -> Enum.at(number, current_digit) end)
      |> Enum.sum()

    most_common_digit = func.(one_count, length)

    list =
      Enum.filter(list, fn number ->
        Enum.at(number, current_digit) == most_common_digit
      end)

    filter(list, current_digit + 1, func)
  end
end
