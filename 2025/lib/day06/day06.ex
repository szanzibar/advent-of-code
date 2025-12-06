defmodule AoC2025.Day06 do
  def parse_input(input) do
    {numbers, [operators]} =
      input
      |> String.trim()
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        String.split(line, ~r/\s+/, trim: true) |> Enum.with_index()
      end)
      |> Enum.split(-1)

    numbers =
      numbers
      |> Enum.map(fn number_list ->
        Enum.map(number_list, fn {number, index} -> {String.to_integer(number), index} end)
      end)

    {numbers, operators}
  end

  @doc """
    iex> part1(AoC2025.Day06.Input.test_input())
    4277556

    iex> part1(AoC2025.Day06.Input.input())
    4309240495780

  """
  def part1(input) do
    {numbers, operators} = parse_input(input)

    [operators | numbers]
    |> List.flatten()
    |> Enum.group_by(fn {_value, index} -> index end, fn {value, _index} -> value end)
    |> Enum.map(fn {_index, [operator | numbers]} ->
      if operator == "*" do
        Enum.product(numbers)
      else
        Enum.sum(numbers)
      end
    end)
    |> Enum.sum()
  end

  @doc """
    iex> part2(AoC2025.Day06.Input.test_input())
    3263827

    iex> part2(AoC2025.Day06.Input.input())
    9170286552289

  """
  def part2(input) do
    parse_input_2(input)
    |> List.flatten()
    |> Enum.group_by(fn {_value, index} -> index end, fn {value, _index} -> value end)
    # this large intermediate map between group_by and chunk_while doesn't have ordered keys!!!
    |> Enum.sort_by(fn {index, _list} -> index end)
    |> Enum.chunk_while(
      # build chunks of vertical slices to construct the numbers
      [],
      fn {_index, [operator | _] = list} = value, acc ->
        cond do
          Enum.all?(list, &(&1 == " ")) ->
            {:cont, acc}

          operator == " " ->
            {:cont, [value | acc]}

          # operator is not " ", meaning end of this chunk
          true ->
            {:cont, Enum.reverse([value | acc]), []}
        end
      end,
      fn
        [] -> {:cont, []}
        acc -> {:cont, Enum.reverse(acc), []}
      end
    )
    |> Enum.map(fn group ->
      {operators, numbers} =
        Enum.map(group, fn {_index, [operator | list]} ->
          {operator, Integer.undigits(Enum.reject(list, &(&1 == " ")))}
        end)
        |> Enum.unzip()

      [operator] = Enum.reject(operators, &(&1 == " "))

      if operator == "+" do
        Enum.sum(numbers)
      else
        Enum.product(numbers)
      end
    end)
    |> Enum.sum()
  end

  defp parse_input_2(input) do
    # make sure input is saved without formatting to preserve leading and trailing whitespace!!
    {numbers, operators} =
      input
      |> String.split("\n")
      |> Enum.map(fn line ->
        String.graphemes(line)
        |> Enum.map(fn grapheme ->
          if grapheme in [" ", "*", "+"] do
            grapheme
          else
            String.to_integer(grapheme)
          end
        end)
        |> Enum.reverse()
        |> Enum.with_index()
      end)
      |> Enum.split(-2)

    [List.flatten(operators) | numbers]
  end
end
