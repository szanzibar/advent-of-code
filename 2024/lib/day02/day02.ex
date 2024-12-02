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
    |> Enum.map(fn line ->
      check_line(line)
    end)
    |> Enum.count(&(&1.safe == true))
  end

  defp check_line(line, one_bad_removed \\ false) do
    reduce_acc = %{direction: nil, one_bad_removed: one_bad_removed, safe: true}

    line
    |> Enum.with_index()
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.reduce_while(reduce_acc, fn [{l, l_index}, {r, r_index}], acc ->
      diff = l - r
      direction = if diff > 0, do: :decreasing, else: :increasing
      valid_step? = abs(diff) in [1, 2, 3]
      acc = if is_nil(acc.direction), do: %{acc | direction: direction}, else: acc

      cond do
        valid_step? && direction == acc.direction ->
          {:cont, acc}

        !acc.one_bad_removed ->
          ll_deleted = check_line(List.delete_at(line, l_index - 1), true)
          left_deleted = check_line(List.delete_at(line, l_index), true)
          right_deleted = check_line(List.delete_at(line, r_index), true)
          rr_deleted = check_line(List.delete_at(line, r_index + 1), true)

          if Enum.any?([ll_deleted.safe, left_deleted.safe, right_deleted.safe, rr_deleted.safe]) do
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
