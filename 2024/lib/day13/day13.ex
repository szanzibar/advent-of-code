defmodule AoC2024.Day13 do
  @moduledoc """
  I think it's just algebra. The first example:
  a = (94, 34)
  b = (22, 67)
  an + bm = (8400, 5400)

  I asked claude to remind me how to do math:
  94n + 22m = 8400  (x-coordinates)
  34n + 67m = 5400  (y-coordinates)

  Multiply 'm's together to eliminate them:
  94n + 22m = 8400 |×67| → 6298n + 1474m = 562800
  34n + 67m = 5400 |×22| → 748n + 1474m = 118800

  And the rest just regular algebra

  I thought I would need more hints today, but besides re-learning how to solve two equations through elimination,
  implementing the math in elixir was all that was needed.
  """

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n\n")
    |> Enum.map(fn claw_machine ->
      String.split(claw_machine, "\n")
      |> Enum.map(fn line ->
        Regex.scan(~r/\d+/, line)
        |> List.flatten()
        |> Enum.map(&String.to_integer/1)
        |> List.to_tuple()
      end)
    end)
  end

  @doc """
    iex> part1(AoC2024.Day13.Input.test_input())
    480

    iex> part1(AoC2024.Day13.Input.input())
    34393

  """
  def part1(input) do
    parse_input(input) |> Enum.map(&calculate_claw_machine/1) |> Enum.sum()
  end

  defp calculate_claw_machine([{xa, ya}, {xb, yb}, {xprize, yprize}]) do
    # two equations for x and y
    # xa + xb = xprize
    # ya + yb = yprize

    # Multiply both equations by the opposite a to eliminate them
    {xb_mult, xprize_mult} = {xb * ya, xprize * ya}
    {yb_mult, yprize_mult} = {yb * xa, yprize * xa}

    # subtract equations from each other, cancelling out 'a'
    # bn = prize
    {b, prize} = {abs(xb_mult - yb_mult), abs(xprize_mult - yprize_mult)}

    # reduce
    # b = prize/b
    reduced_b = prize / b

    # plug in to original equation to solve for a
    # xa + (xb * reduced_b) = xprize
    # xa = xprize - (xb * reduced_b)
    # x = (xprize - (xb * reduced_b) / xa)
    a = abs(xprize - xb * reduced_b)
    reduced_a = a / xa

    case {trunc(reduced_a), trunc(reduced_b)} do
      {a, b} when a == reduced_a and b == reduced_b ->
        # success
        a * 3 + b

      _ ->
        # I assume if this isn't a whole number the problem isn't solvable
        0
    end
  end

  @doc """
    iex> part2(AoC2024.Day13.Input.test_input())
    875318608908

    iex> part2(AoC2024.Day13.Input.input())
    83551068361379

  """
  def part2(input) do
    parse_input(input)
    |> Enum.map(fn [a, b, {xprize, yprize}] ->
      calculate_claw_machine([a, b, {xprize + 10_000_000_000_000, yprize + 10_000_000_000_000}])
    end)
    |> Enum.sum()
  end
end
