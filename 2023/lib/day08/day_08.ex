defmodule AoC2023.Day08 do
  def get_input(input) do
    [instructions, nodes] = input |> String.trim() |> String.split("\n\n")

    mapped_nodes =
      nodes
      |> String.split("\n")
      |> Enum.map(fn line ->
        [elem, left, right] = line |> String.split([" = (", ", ", ")"], trim: true)

        {elem, {left, right}}
      end)
      |> Map.new()

    {instructions |> String.codepoints(), mapped_nodes}
  end

  @doc """
    iex> part1(AoC2023.Day08.Input.test_input())
    2

    iex> part1(AoC2023.Day08.Input.test_input_2())
    6

    iex> part1(AoC2023.Day08.Input.input())
    16271

  """
  def part1(input) do
    {instructions, nodes} = get_input(input)

    %{
      instructions: instructions,
      original_instructions: instructions,
      key: "AAA",
      nodes: nodes,
      count: 0
    }
    |> follow_instructions()
  end

  def follow_instructions(%{key: "ZZZ", count: count}), do: count
  def follow_instructions(%{key: <<_::16>> <> "Z", count: count}), do: count

  def follow_instructions(%{instructions: [], original_instructions: oi} = params),
    do: follow_instructions(%{params | instructions: oi})

  def follow_instructions(
        %{
          instructions: [l_or_r | instructions_tail],
          key: key,
          nodes: nodes,
          count: count
        } = params
      ) do
    {l, r} = Map.get(nodes, key)

    new_key = if l_or_r == "L", do: l, else: r

    follow_instructions(%{
      params
      | key: new_key,
        instructions: instructions_tail,
        count: count + 1
    })
  end

  @doc """
    iex> part2(AoC2023.Day08.Input.test_input_part_2())
    6

    iex> part2(AoC2023.Day08.Input.input())
    14265111103729

  """
  def part2(input) do
    {instructions, nodes} = get_input(input)

    Map.keys(nodes)
    |> Enum.filter(&String.ends_with?(&1, "A"))
    |> Enum.map(fn start_key ->
      Task.async(fn ->
        %{
          instructions: instructions,
          original_instructions: instructions,
          key: start_key,
          nodes: nodes,
          count: 0
        }
        |> follow_instructions()
      end)
    end)
    |> Task.await_many()
    |> Enum.reduce(1, fn count, acc ->
      # least common multiple is count_a * count_b / greatest common divisor
      Integer.floor_div(acc * count, Integer.gcd(acc, count))
    end)
  end
end
