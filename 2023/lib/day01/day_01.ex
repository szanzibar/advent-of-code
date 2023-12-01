defmodule AoC2023.Day01 do
  def get_input(file) do
    File.read!(Path.join(__DIR__, file))
    |> String.split("\n")
  end

  @doc """
    iex> part1("test_input")
    142

    iex> part1("input")
    nil

  """
  def part1(input_file) do
    get_input(input_file)
    |> Enum.reduce(0, fn line, acc ->
      numbers = Regex.scan(~r/\d/, line) |> List.flatten()
      {num, _} = [Enum.at(numbers, 0), Enum.at(numbers, -1)] |> Enum.join() |> Integer.parse()
      acc + num
    end)
  end

  @doc """
    # iex> part2("test_input")
    # nil

    # iex> part2("input")
    # nil

  """
  def part2(input_file) do
    get_input(input_file)
  end
end
