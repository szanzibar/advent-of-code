defmodule AoC2022.Day05 do
  def get_input(file) do
    [stack, instructions] = File.read!(Path.join(__DIR__, file)) |> String.split("\n\n")

    stack =
      stack
      |> String.split("\n")
      |> Enum.map(fn line ->
        line
        |> String.to_charlist()
        |> Enum.chunk_every(4)
        |> Enum.map(fn chunk ->
          chunk |> to_string |> String.trim() |> String.trim("[") |> String.trim("]")
        end)
      end)

    instructions =
      instructions
      |> String.split("\n")
      |> Enum.map(fn instruction ->
        Regex.scan(~r/\d+/, instruction)
        |> Enum.map(fn [match] -> String.to_integer(match) end)
      end)

    {stack, instructions}
  end

  @doc """
      iex> part1("test_input")
      "CMZ"

      iex> part1("input")
      "SBPQRSCDF"

  """
  def part1(input_file) do
    {raw_stack, instructions} = get_input(input_file)
    stacks = build_stacks(raw_stack)

    moved = move(stacks, instructions)

    tops =
      moved
      |> Enum.sort_by(fn {k, _v} -> k end)
      |> Enum.map(fn {_k, v} -> Enum.at(v, 0) end)
      |> Enum.join()

    tops
  end

  defp move(stack, []), do: stack

  defp move(stacks, [instruction | instructions]) do
    stacks = transfer(stacks, instruction)

    move(stacks, instructions)
  end

  defp transfer(stacks, [0, _, _]), do: stacks

  defp transfer(stacks, [amount, from, to]) do
    {[value], new_from} = Enum.split(stacks[from], 1)
    new_to = [value | stacks[to]]
    stacks = %{stacks | from => new_from, to => new_to}
    transfer(stacks, [amount - 1, from, to])
  end

  defp build_stacks(raw_stack) do
    for stack_index <- 0..(Enum.count(raw_stack |> Enum.at(0)) - 1) do
      Enum.map(raw_stack, fn layer ->
        Enum.at(layer, stack_index)
      end)
      |> Enum.filter(fn value -> value != "" end)
      |> Enum.drop(-1)
    end
    |> Enum.with_index()
    |> Map.new(fn {list, index} -> {index + 1, list} end)
  end

  @doc """
      iex> part2("test_input")
      "MCD"

      iex> part2("input")
      "RGLVRCQSB"

  """
  def part2(input_file) do
    {raw_stack, instructions} = get_input(input_file)
    stacks = build_stacks(raw_stack)

    moved = move_multiple(stacks, instructions)

    tops =
      moved
      |> Enum.sort_by(fn {k, _v} -> k end)
      |> Enum.map(fn {_k, v} -> Enum.at(v, 0) end)
      |> Enum.join()

    tops
  end

  defp move_multiple(stack, []), do: stack

  defp move_multiple(stacks, [[amount, from, to] | instructions]) do
    {value, new_from} = Enum.split(stacks[from], amount)
    new_to = Enum.concat(value, stacks[to])
    stacks = %{stacks | from => new_from, to => new_to}

    move_multiple(stacks, instructions)
  end
end
