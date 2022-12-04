defmodule AoC2022.Day04 do
  def get_input(file) do
    File.read!(Path.join(__DIR__, file))
    |> String.split("\n")
    |> Enum.map(fn pair ->
      pair
      |> String.split(",")
      |> Enum.map(fn section ->
        section |> String.split("-") |> Enum.map(&String.to_integer/1)
      end)
    end)
  end

  @doc """
      iex> part1("test_input")
      2

      iex> part1("input")
      573

  """
  def part1(input_file) do
    get_input(input_file)
    |> Enum.map(fn [[a, b], [x, y]] ->
      cond do
        a >= x && b <= y -> 1
        x >= a && y <= b -> 1
        true -> 0
      end
    end)
    |> Enum.sum()
  end

  @doc """
      iex> part2("test_input")
      4

      iex> part2("input")
      867

  """
  def part2(input_file) do
    get_input(input_file)
    |> Enum.map(fn [[a, b], [x, y]] ->
      cond do
        b >= x && x >= a -> 1
        y >= a && a >= x -> 1
        true -> 0
      end
    end)
    |> Enum.sum()
  end

  @doc """
    Trying out the sets way. (Based on how Cody solved it, but without looking at his code.)

      iex> part1_sets("test_input")
      2

      iex> part1_sets("input")
      573

  """
  def part1_sets(input_file) do
    get_input(input_file)
    |> Enum.map(fn [[a, b], [x, y]] ->
      first = MapSet.new(a..b)
      second = MapSet.new(x..y)

      MapSet.subset?(first, second) ||
        MapSet.subset?(second, first)
    end)
    |> Enum.filter(& &1)
    |> Enum.count()
  end

  @doc """
    Trying out the sets way. (Based on how Cody solved it, but without looking at his code.)

      iex> part2("test_input")
      4

      iex> part2("input")
      867

  """
  def part2_sets(input_file) do
    get_input(input_file)
    |> Enum.map(fn [[a, b], [x, y]] ->
      first = MapSet.new(a..b)
      second = MapSet.new(x..y)

      MapSet.intersection(first, second)
    end)
    |> Enum.filter(& &1)
    |> Enum.count()
  end
end
