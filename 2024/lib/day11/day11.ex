defmodule AoC2024.Day11 do
  require Integer

  def parse_input(input) do
    input |> String.trim() |> String.split(" ") |> Enum.map(&String.to_integer/1)
  end

  @doc """
    iex> part1(AoC2024.Day11.Input.test_input())
    55312

    iex> part1(AoC2024.Day11.Input.input())
    193899

  """
  def part1(input) do
    parse_input(input) |> Enum.map(&blink(&1, 25)) |> List.flatten() |> Enum.count()
  end

  defp blink(number, 0), do: number

  defp blink(number, count) when is_list(number) do
    Enum.map(number, &blink(&1, count))
  end

  defp blink(0, count) when count >= 7,
    do: blink([4, 0, 4, 8, 20, 24, 4, 0, 4, 8, 8, 0, 9, 6], count - 7)

  defp blink(0, count), do: blink(1, count - 1)
  defp blink(1, count), do: blink(2024, count - 1)
  defp blink(2024, count), do: blink([20, 24], count - 1)
  defp blink(20, count), do: blink([2, 0], count - 1)
  defp blink(24, count), do: blink([2, 4], count - 1)
  defp blink(2, count), do: blink(4048, count - 1)
  defp blink(4, count), do: blink(8096, count - 1)
  defp blink(6, count), do: blink(12144, count - 1)
  defp blink(8, count), do: blink(16192, count - 1)

  defp blink(number, count) do
    digits = Integer.digits(number)
    digit_length = length(digits)

    if Integer.is_even(digit_length) do
      half = Integer.floor_div(digit_length, 2)

      chunks =
        Enum.chunk_every(digits, half)
        |> Enum.map(&Integer.undigits/1)

      blink(chunks, count - 1)
    else
      blink(2024 * number, count - 1)
    end
  end

  @doc """
    # iex> part2(AoC2024.Day11.Input.test_input())
    # nil

    # iex> part2(AoC2024.Day11.Input.input())
    # nil

  """
  def part2(input) do
    tasks_50 =
      parse_input(input)
      |> Enum.map(&blink(&1, 25))
      |> List.flatten()
      |> Enum.with_index()
      |> Enum.map(fn {number, index} ->
        Task.async(fn ->
          {List.flatten(blink(number, 25)), index}
        end)
      end)
      |> Task.await_many(:infinity)

    # |> Enum.map(&blink(&1, 25))
  end
end
