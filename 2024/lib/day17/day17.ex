defmodule AoC2024.Day17 do
  @moduledoc """
  I've spent hours trying to implement a solution even _after_ understanding
  multiple ways to solve part 2 after reading reddit hints.

  I'm left realizing what a colossal fucking waste of time Advent of code is.
  I thought I could run through the last days with heavy hints and it's just
  such a fuuuucking waste of time. I'm left feeling resentful for all the holiday
  time lost. The joy is utterly gone. I'm done for the year.
  """

  def parse_input(input) do
    [registers, program] = input |> String.trim() |> String.split("\n\n")

    [a, b, c] =
      registers
      |> String.split("\n")
      |> Enum.map(fn register ->
        String.split(register, ": ") |> List.last() |> String.to_integer()
      end)

    program =
      program
      |> String.split(": ")
      |> List.last()
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    %{
      a: a,
      b: b,
      c: c,
      program: program,
      pointer: 0,
      output: []
    }
  end

  @doc """
    iex> part1(AoC2024.Day17.Input.test_input())
    "4,6,3,5,6,3,5,2,1,0"

    iex> part1(AoC2024.Day17.Input.input())
    "3,4,3,1,7,6,5,6,0"

  """
  def part1(input) do
    finished = parse_input(input) |> next()

    finished.output |> Enum.reverse() |> Enum.join(",")
  end

  defp next(p) do
    Enum.slice(p.program, p.pointer, 2)
    |> case do
      [inst, op] ->
        case inst do
          0 -> adv(p, op)
          1 -> bxl(p, op)
          2 -> bst(p, op)
          3 -> jnz(p, op)
          4 -> bxc(p, op)
          5 -> out(p, op)
          6 -> bdv(p, op)
          7 -> cdv(p, op)
        end
        |> next

      _ ->
        p
    end
  end

  defp adv(p, operand) do
    %{p | a: Integer.floor_div(p.a, Integer.pow(2, combo_op(p, operand)))} |> finish
  end

  defp bxl(p, operand) do
    %{p | b: Bitwise.bxor(p.b, operand)} |> finish
  end

  defp bst(p, operand) do
    %{p | b: Integer.mod(combo_op(p, operand), 8)} |> finish
  end

  defp jnz(%{a: 0} = p, _), do: finish(p)
  defp jnz(p, operand), do: %{p | pointer: operand}

  defp bxc(p, _operand) do
    %{p | b: Bitwise.bxor(p.b, p.c)} |> finish
  end

  defp out(p, operand) do
    %{p | output: [Integer.mod(combo_op(p, operand), 8) | p.output]} |> finish
  end

  defp bdv(p, operand) do
    %{p | b: Integer.floor_div(p.a, Integer.pow(2, combo_op(p, operand)))} |> finish
  end

  defp cdv(p, operand) do
    %{p | c: Integer.floor_div(p.a, Integer.pow(2, combo_op(p, operand)))} |> finish
  end

  defp combo_op(p, 4), do: p.a
  defp combo_op(p, 5), do: p.b
  defp combo_op(p, 6), do: p.c
  defp combo_op(_, 7), do: nil
  defp combo_op(_, operand), do: operand

  defp finish(p), do: %{p | pointer: p.pointer + 2}

  @doc """
    # iex> part2(AoC2024.Day17.Input.test_input2())
    # 117440

    iex> part2(AoC2024.Day17.Input.input())
    nil

  """
  def part2(input) do
    program = parse_input(input)

    # number = 0o3102000000000020

    valid_next_digits(program)
  end

  defp valid_next_digits(p, digits \\ []) do
    0..0o777777
  end

  # defp valid_next_digits(p, digits \\ []) do
  #   0..7
  #   |> Enum.map(fn next_digit ->
  #     new_digits = [next_digit | digits]
  #     number = new_digits |> Enum.reverse() |> Integer.undigits(8)
  #     %{output: output, program: program} = %{p | a: number} |> next

  #     if Enum.slice(program, 0, length(new_digits)) == output do
  #       IO.inspect(%{digits: new_digits, output: output, program: program})
  #       # keep
  #       valid_next_digits(p, new_digits)
  #     end
  #   end)
  # end
end
