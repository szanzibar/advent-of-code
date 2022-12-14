defmodule AoC2022.Day03 do
  def get_input(file) do
    File.read!(Path.join(__DIR__, file)) |> String.split("\n") |> Enum.map(&String.to_charlist/1)
  end

  @doc """
      iex> part1("test_input")
      157

      iex> part1("input")
      8240

  """
  def part1(input_file) do
    get_input(input_file)
    |> Enum.map(fn rucksack ->
      length = Enum.count(rucksack)
      {comp1, comp2} = Enum.split(rucksack, div(length, 2))

      set1 = MapSet.new(comp1)
      set2 = MapSet.new(comp2)

      MapSet.intersection(set1, set2)
      |> MapSet.to_list()
      |> get_value()
    end)
    |> Enum.sum()
  end

  defp get_value([character]) do
    if character < 97 do
      character - 65 + 27
    else
      character - 97 + 1
    end
  end

  @doc """
      iex> part2("test_input")
      70

      iex> part2("input")
      2587

  """
  def part2(input_file) do
    get_input(input_file)
    |> Enum.map(&MapSet.new/1)
    |> Enum.chunk_every(3)
    |> Enum.map(fn group ->
      group
      |> Enum.reduce(fn rucksack, acc ->
        MapSet.intersection(rucksack, acc)
      end)
      |> MapSet.to_list()
      |> get_value()
    end)
    |> Enum.sum()
  end
end
