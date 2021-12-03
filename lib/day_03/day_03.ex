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
end
