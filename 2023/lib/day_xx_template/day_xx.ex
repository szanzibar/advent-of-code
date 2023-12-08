defmodule AoC2023.Dayxx do
  def get_input(file) do
    File.read!(Path.join(__DIR__, file))
  end

  @doc """
    iex> part1(AoC2023.Dayxx.Input.test_input())
    nil

    # iex> part1(AoC2023.Dayxx.Input.input())
    # nil

  """
  def part1(input_file) do
    get_input(input_file)
  end

  @doc """
    # iex> part2(AoC2023.Dayxx.Input.test_input())
    # nil

    # iex> part2(AoC2023.Dayxx.Input.input())
    # nil

  """
  def part2(input_file) do
    get_input(input_file)
  end
end
