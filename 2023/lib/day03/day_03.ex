defmodule AoC2023.Day03 do
  def get_input(file) do
    File.read!(Path.join(__DIR__, file))
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, row} ->
      line
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.map(fn {char, col} ->
        {{row, col}, {char, false}}
      end)
    end)
    |> Enum.filter(fn {_, {value, _}} -> value != "." end)
    |> Enum.split_with(fn {_, {char, _}} ->
      String.match?(char, ~r/\d/)
    end)
  end

  @doc """
    iex> part1("test_input")
    4361

    iex> part1("input")
    525181

  """
  def part1(input_file) do
    {numbers, symbols} = get_input(input_file)

    symbols
    |> Enum.reduce(Map.new(numbers), fn {coord, val}, numbers_acc ->
      touches_number(numbers_acc, {coord, val})
    end)
    # dealing with numbers now
    |> Enum.sort()
    |> chunk_numbers
    |> Enum.filter(fn {_num, touching} -> touching end)
    |> Enum.map(fn {num, _} -> parse_num(num) end)
    |> Enum.sum()
  end

  defp chunk_numbers(numbers) do
    chunk_fun = fn
      {{row, col}, _} = element, [{{previous_row, previous_col}, _} | _] = acc ->
        if row == previous_row && col == previous_col + 1 do
          {:cont, [element | acc]}
        else
          {:cont, Enum.reverse(acc), [element]}
        end

      element, acc ->
        {:cont, [element | acc]}
    end

    after_fun = fn acc -> {:cont, Enum.reverse(acc), []} end

    numbers
    |> Enum.chunk_while([], chunk_fun, after_fun)
    |> Enum.map(fn number_chunk ->
      number_chunk
      |> Enum.reduce({"", false}, fn {_coord, {num, touching}}, {num_acc, touching_acc} ->
        {num_acc <> num, touching || touching_acc}
      end)
    end)
  end

  # Returns numbers with coord of any touching symbol
  defp touches_number(numbers, {{row, col} = symbol_coord, _}) do
    [
      {row - 1, col - 1},
      {row - 1, col},
      {row - 1, col + 1},
      {row, col - 1},
      {row, col + 1},
      {row + 1, col - 1},
      {row + 1, col},
      {row + 1, col + 1}
    ]
    |> Enum.reduce(numbers, fn coord, numbers_acc ->
      Map.get(numbers_acc, coord)
      |> case do
        nil -> numbers_acc
        {val, _} -> Map.put(numbers_acc, coord, {val, symbol_coord})
      end
    end)
  end

  @doc """
    iex> part2("test_input")
    467835

    iex> part2("input")
    84289137

  """
  def part2(input_file) do
    {numbers, symbols} = get_input(input_file)

    symbols
    |> Enum.reduce(Map.new(numbers), fn {coord, val}, numbers_acc ->
      touches_number(numbers_acc, {coord, val})
    end)
    # dealing with numbers now
    |> Enum.sort()
    |> chunk_numbers
    |> Enum.filter(fn {_num, touching} -> touching end)
    |> Enum.map(fn {num, coord} -> {coord, parse_num(num)} end)
    |> Enum.sort()
    |> Enum.chunk_by(fn {symbol_coord, _num} -> symbol_coord end)
    |> Enum.filter(fn chunk -> Enum.count(chunk) == 2 end)
    |> Enum.map(fn chunk ->
      chunk |> Enum.map(fn {_coord, num} -> num end) |> Enum.product()
    end)
    |> Enum.sum()
  end

  defp parse_num(num) do
    {num, _} = Integer.parse(num)
    num
  end
end
