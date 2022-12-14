defmodule AoC2022.Day01 do
  def get_input(file) do
    File.read!(Path.join(__DIR__, file))
    |> String.split("\n\n")
    |> Enum.map(fn elf -> String.split(elf, "\n") |> Enum.map(&String.to_integer/1) end)
  end

  @doc """
      iex> part1("test_input")
      24000

      iex> part1("input")
      75501

  """
  def part1(input_file) do
    get_input(input_file)
    |> Enum.map(&Enum.sum/1)
    |> Enum.max()
  end

  @doc """
      iex> part2("test_input")
      45000

      iex> part2("input")
      215594

  """
  def part2(input_file) do
    get_input(input_file)
    |> Enum.map(&Enum.sum/1)
    |> Enum.sort()
    |> Enum.take(-3)
    |> Enum.sum()
  end
end
