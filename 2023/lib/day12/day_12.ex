defmodule AoC2023.Day12 do
  require Logger

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [springs, broken, expected] = String.split(line, [" ", ":"])
      split_springs = springs |> String.split(".", trim: true)
      split_broken = broken |> String.split(",") |> Enum.map(&String.to_integer/1)
      sizes = split_springs |> Enum.map(&String.length/1)

      %{
        length: String.length(springs),
        sizes: sizes,
        split_springs: split_springs,
        split_broken: split_broken,
        expected: String.to_integer(expected)
      }
    end)
  end

  @doc """
    iex> part1(AoC2023.Day12.Input.test_input())
    21

    # iex> part1(AoC2023.Day12.Input.input())
    # nil

  """
  def part1(input) do
    parse_input(input)
    |> dbg
    |> Enum.map(fn line ->
      build_all_possibilities(line.length, line.split_broken)
    end)
  end

  def build_all_possibilities(length, split_broken) do
    length |> IO.inspect()

    possible_space_count =
      (length - Enum.sum(split_broken) - (length(split_broken) - 1)) |> IO.inspect()

    chunks = split_broken |> Enum.map(fn num -> String.duplicate("#", num) end)

    spaces =
      chunks
      |> Enum.map(fn _ -> 1 end)
      |> List.update_at(-1, fn _ -> possible_space_count end)
      |> IO.inspect()

    possible_space_arrangements = generate_spaces(spaces, possible_space_count)
  end

  def generate_spaces(spaces, possible_space_count) do
    Enum.flat_map(0..(length(spaces) - 1), fn index ->
      Enum.map(1..possible_space_count, fn count ->
        List.update_at(spaces, index, fn _ -> count end)
      end)
    end)
    |> dbg
  end

  # def part1(input) do
  #   parse_input(input)
  #   |> Enum.map(fn params = line ->
  #     calculate(params)
  #   end)
  #   |> Enum.reject(fn map -> map.expected == map[:arrangements] end)

  #   # |> dbg(charlists: :as_lists)
  # end

  # if sizes == split_broken, exactly 1 possible arrangement
  def calculate(%{sizes: sizes, split_broken: split_broken} = line) when sizes == split_broken,
    do: Map.put(line, :arrangements, 1)

  # if length(sizes) = length(split_broken), each range can only be arranged in corrisponding size_range
  def calculate(%{sizes: sizes, split_broken: split_broken} = line)
      when length(sizes) == length(split_broken) do
    amount =
      Enum.zip(sizes, split_broken)
      |> Enum.map(fn {size, broken} ->
        diff = size - broken
        if diff == 0, do: 0, else: diff + 1
      end)
      |> Enum.sum()

    Map.put(line, :arrangements, amount)
  end

  # need to calcualet when length(sizes) != length(split_broken)

  # def calculate(
  #       %{
  #         sizes: sizes,
  #         split_springs: split_springs,
  #         split_broken: split_broken
  #       } = line
  #     ) do
  #   IO.inspect(line, charlists: :as_lists)
  #   current_arrangements = Map.get(line, :arrangements, 0)
  #   first_size = Enum.at(sizes, 0)
  #   first_split_broken = Enum.at(split_broken, 0)
  #   list_size = Enum.at(sizes, -1)
  #   last_split_broken = Enum.at(split_broken, -1)

  #   chunk_size = length(split_broken) - length(sizes) + 1
  #   step_size = if length(split_broken) == 1, do: chunk_size, else: 1

  #   split_broken_chunks =
  #     if chunk_size > 1 do
  #       Enum.chunk_every(split_broken, chunk_size, step_size, :discard) |> dbg
  #     else
  #       []
  #     end

  #   if length(split_broken_chunks) != length(sizes) and length(split_broken) > length(sizes),
  #     do: Logger.error("aaaaaaaaaaaaaaaaaaaaa")

  #   cond do
  #     first_size == first_split_broken ->
  #       %{
  #         line
  #         | sizes: List.delete_at(sizes, 0),
  #           split_broken: List.delete_at(split_broken, 0),
  #           split_springs: List.delete_at(split_springs, 0)
  #       }
  #       |> Map.put(:arrangements, add_arrangements(current_arrangements, 1))
  #       |> calculate()

  #     list_size == last_split_broken ->
  #       %{
  #         line
  #         | sizes: List.delete_at(sizes, -1),
  #           split_broken: List.delete_at(split_broken, -1),
  #           split_springs: List.delete_at(split_springs, -1)
  #       }
  #       |> Map.put(:arrangements, add_arrangements(current_arrangements, 1))
  #       |> calculate()

  #     Enum.sum(split_broken) + length(split_broken) - 1 == Enum.sum(sizes) + length(sizes) - 1 ->
  #       IO.inspect(current_arrangements)
  #       Map.put(line, :arrangements, add_arrangements(current_arrangements, 1))

  #     # inequal splits and sizes
  #     length(split_broken) > length(sizes) && length(sizes) > 1 ->

  #     true ->
  #       line
  #   end
  # end

  # def calculate(line), do: line

  # def add_arrangements(0, a2), do: a2
  # def add_arrangements(a1, 0), do: a1
  # def add_arrangements(a1, a2), do: a1 + a2 - 1

  @doc """
    # iex> part2(AoC2023.Day12.Input.test_input())
    # nil

    # iex> part2(AoC2023.Day12.Input.input())
    # nil

  """
  def part2(input) do
    parse_input(input)
  end
end
