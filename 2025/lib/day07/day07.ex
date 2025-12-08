defmodule AoC2025.Day07 do
  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn row ->
      row
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.map(fn {char, col} ->
        char = if char == ".", do: 0, else: char
        {col, char}
      end)
      |> Map.new()
    end)
  end

  @doc """
    iex> part1(AoC2025.Day07.Input.test_input())
    21

    iex> part1(AoC2025.Day07.Input.input())
    1570

  """
  def part1(input) do
    [row | rows] = parse_input(input)

    {starting_col, _S} = Enum.find(row, fn {_col, value} -> value == "S" end)
    beamed_rows = process_rows(rows, [{starting_col, 1}])
    count_splits(beamed_rows)
  end

  defp count_splits(beamed_rows) do
    full_grid =
      Enum.with_index(beamed_rows)
      |> Enum.flat_map(fn {row, row_index} ->
        Enum.map(row, fn {col, value} -> {{row_index, col}, value} end)
      end)
      |> Map.new()

    Utils.print_map(full_grid)

    splitters = Enum.filter(full_grid, fn {_coords, value} -> value == "^" end)

    Enum.count(splitters, fn {{row, col}, _splitter} ->
      # it was split if a splitter has a beam above it
      Map.get(full_grid, {row - 1, col}) > 0
    end)
  end

  defp process_rows(rows, beam_coords, finished_rows \\ [])
  defp process_rows([], _, finished_rows), do: finished_rows |> Enum.reverse()

  defp process_rows([row | future_rows], beam_coords, finished_rows) do
    # Each row get current row, future rows, and beams from previous row
    # get beams for next row
    row_with_beams =
      Enum.reduce(beam_coords, row, fn col, acc_row ->
        add_beam(acc_row, col)
      end)

    next_beam_coords =
      Enum.filter(row_with_beams, fn {_col, value} -> is_integer(value) && value > 0 end)

    process_rows(future_rows, next_beam_coords, [row_with_beams | finished_rows])
  end

  defp add_beam(row, {beam_col, previous_value}) do
    case Map.get(row, beam_col) do
      "^" ->
        left = Map.get(row, beam_col - 1)
        right = Map.get(row, beam_col + 1)

        row
        |> Map.put(beam_col - 1, left + previous_value)
        |> Map.put(beam_col + 1, right + previous_value)

      value when is_integer(value) ->
        # this column has already been beamed
        existing_value = Map.get(row, beam_col)
        Map.put(row, beam_col, existing_value + previous_value)

      something_else ->
        IO.inspect(something_else, label: "WTF")
    end
  end

  @doc """
    iex> part2(AoC2025.Day07.Input.test_input())
    40

    iex> part2(AoC2025.Day07.Input.input())
    15118009521693

  """
  def part2(input) do
    [row | rows] = parse_input(input)

    {starting_col, _S} = Enum.find(row, fn {_col, value} -> value == "S" end)
    beamed_rows = process_rows(rows, [{starting_col, 1}])

    [last_row | _] = Enum.reverse(beamed_rows)
    Enum.map(last_row, fn {_coord, value} -> value end) |> Enum.sum()
  end
end
