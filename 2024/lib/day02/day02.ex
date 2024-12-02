defmodule AoC2024.Day02 do
  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      String.split(line, " ", trim: true) |> Enum.map(&String.to_integer/1)
    end)
  end

  @doc """
    iex> part1(AoC2024.Day02.Input.test_input())
    2

    iex> part1(AoC2024.Day02.Input.input())
    218

  """
  def part1(input) do
    parse_input(input)
    |> only_increasing_decreasing
    |> only_change_by_1_to_3
    |> Enum.sum()
  end

  defp only_increasing_decreasing(data) do
    Enum.filter(data, fn line ->
      line == Enum.sort(line, :asc) || line == Enum.sort(line, :desc)
    end)
  end

  defp only_change_by_1_to_3(data) do
    Enum.map(data, fn line ->
      line
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.reduce_while(1, fn [l, r], acc ->
        case abs(l - r) do
          diff when diff in [1, 2, 3] ->
            {:cont, acc}

          _ ->
            {:halt, 0}
        end
      end)
    end)
  end

  @doc """
    iex> part2(AoC2024.Day02.Input.test_input())
    4

    iex> part2(AoC2024.Day02.Input.input())
    290
    # >267
    # >287

  """
  def part2(input) do
    parse_input(input)
    |> Enum.map(&check_line/1)
    |> Enum.count(& &1.safe)
  end

  defp check_line(line, opts \\ []) do
    reduce_init = %{
      direction: nil,
      one_bad_removed: Keyword.get(opts, :one_bad_removed, false),
      safe: true
    }

    line
    |> Enum.with_index()
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.reduce_while(reduce_init, fn [{l, l_index}, {r, r_index}], acc ->
      direction = if l > r, do: :decreasing, else: :increasing
      valid_step? = abs(l - r) in [1, 2, 3]

      cond do
        valid_step? && is_nil(acc.direction) ->
          {:cont, %{acc | direction: direction}}

        valid_step? && direction == acc.direction ->
          {:cont, acc}

        !acc.one_bad_removed ->
          (l_index - 1)..(r_index + 1)
          |> Enum.map(&check_line(List.delete_at(line, &1), one_bad_removed: true).safe)
          |> Enum.any?()
          |> if do
            {:halt, acc}
          else
            {:halt, %{acc | safe: false}}
          end

        true ->
          {:halt, %{acc | safe: false}}
      end
    end)
  end
end
