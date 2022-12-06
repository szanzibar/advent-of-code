defmodule AoC2022.Day06 do
  def get_input(file) do
    File.read!(Path.join(__DIR__, file))
    |> String.split("\n")
    |> Enum.map(fn line ->
      line |> String.to_charlist()
    end)
  end

  @doc """
      iex> part1("test_input")
      [7, 5, 6, 10, 11]

      iex> part1("input")
      [1300]

  """
  def part1(input_file) do
    get_input(input_file)
    |> Enum.map(fn line ->
      {_chunk, index} =
        line
        |> Enum.chunk_every(4, 1)
        |> Enum.with_index()
        |> Enum.find(fn {chunk, _index} ->
          Enum.uniq(chunk) |> Enum.count() == 4
        end)

      index + 4
    end)
  end

  @doc """
      iex> part2("test_input")
      [19, 23, 23, 29, 26]

      iex> part2("input")
      [3986]

  """
  def part2(input_file) do
    get_input(input_file)
    |> Enum.map(fn line ->
      {_chunk, index} =
        line
        |> Enum.chunk_every(14, 1)
        |> Enum.with_index()
        |> Enum.find(fn {chunk, _index} ->
          Enum.uniq(chunk) |> Enum.count() == 14
        end)

      index + 14
    end)
  end
end
