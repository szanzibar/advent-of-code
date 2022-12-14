defmodule AoC2022.Day11 do
  alias AoC2022.Day11.Input

  @doc """
    iex> part1("test_input")
    10605

    iex> part1("input")
    117624

  """
  def part1(input) do
    if(input == "test_input", do: Input.get_test_input(), else: Input.get_input())
    |> process_round(20)
    |> Enum.map(fn {_k, v} -> v.inspect_count end)
    |> Enum.sort()
    |> Enum.take(-2)
    |> Enum.product()
  end

  def process_round(monkeys, 0), do: monkeys

  def process_round(monkeys, round) do
    process_monkey(monkeys, 0)
    |> process_round(round - 1)
  end

  def process_monkey(monkeys, monkey) when monkey == map_size(monkeys), do: monkeys

  def process_monkey(monkeys, monkey) do
    key = "monkey_#{monkey}"

    process_monkey_items(monkeys, monkeys[key].items, key)
    |> process_monkey(monkey + 1)
  end

  def process_monkey_items(monkeys, [], key) do
    put_in(monkeys, [key, :items], [])
  end

  def process_monkey_items(monkeys, [item | items], key) do
    {_, monkeys} =
      get_and_update_in(monkeys, [key, :inspect_count], fn count -> {count, count + 1} end)

    worry = monkeys[key].operation.(item) |> div(3)
    new_monkey = monkeys[key].test.(worry)

    {_, monkeys} =
      get_and_update_in(monkeys, [new_monkey, :items], fn existing_items ->
        {existing_items, existing_items ++ [worry]}
      end)

    process_monkey_items(monkeys, items, key)
  end

  @doc """
    I cheated in this part a bit, to look up how to use the lcm. This kinda problem isn't fun :(

    iex> part2("test_input")
    2713310158

    iex> part2("input")
    16792940265

  """
  def part2(input) do
    monkeys = if(input == "test_input", do: Input.get_test_input(), else: Input.get_input())

    lcm =
      monkeys
      |> Enum.reduce(1, fn {_, monkey}, acc -> lcm(monkey.divisor, acc) end)

    monkeys
    |> process_round_2(10000, lcm)
    |> Enum.map(fn {_k, v} -> v.inspect_count end)
    |> Enum.sort()
    |> Enum.take(-2)
    |> Enum.product()
  end

  def process_round_2(monkeys, 0, _), do: monkeys

  def process_round_2(monkeys, round, lcm) do
    process_monkey_2(monkeys, 0, lcm) |> process_round_2(round - 1, lcm)
  end

  def process_monkey_2(monkeys, monkey, _) when monkey == map_size(monkeys), do: monkeys

  def process_monkey_2(monkeys, monkey, lcm) do
    key = "monkey_#{monkey}"

    process_monkey_items_2(monkeys, monkeys[key].items, key, lcm)
    |> process_monkey_2(monkey + 1, lcm)
  end

  def process_monkey_items_2(monkeys, [], key, _) do
    put_in(monkeys, [key, :items], [])
  end

  def process_monkey_items_2(monkeys, [item | items], key, lcm) do
    {_, monkeys} =
      get_and_update_in(monkeys, [key, :inspect_count], fn count -> {count, count + 1} end)

    worry = monkeys[key].operation.(item)
    remainder = rem(worry, lcm)

    new_monkey = monkeys[key].test.(remainder)

    {_, monkeys} =
      get_and_update_in(monkeys, [new_monkey, :items], fn existing_items ->
        {existing_items, existing_items ++ [remainder]}
      end)

    process_monkey_items_2(monkeys, items, key, lcm)
  end

  def lcm(a, b), do: div(a * b, Integer.gcd(a, b))
end
