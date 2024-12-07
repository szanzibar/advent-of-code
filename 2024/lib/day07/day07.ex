defmodule AoC2024.Day07 do
  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn line ->
      [solution, numbers] = String.split(line, ": ")
      solution = String.to_integer(solution)
      numbers = numbers |> String.split(" ")
      {solution, numbers}
    end)
  end

  @doc """
    iex> part1(AoC2024.Day07.Input.test_input())
    3749

    iex> part1(AoC2024.Day07.Input.input())
    28730327770375

  """
  def part1(input) do
    parse_input(input)
    |> Enum.map(fn line ->
      evaluate_line(line)
    end)
    |> Enum.reject(&is_nil/1)
    |> Enum.sum()
  end

  defp evaluate_line({answer, numbers}) do
    length = length(numbers)
    operators = get_operator_list(length - 1) |> Enum.map(fn list -> list ++ [""] end)

    possibilities =
      Enum.map(operators, fn operator_list ->
        pairs =
          Enum.zip(numbers, operator_list)
          |> Enum.map(&Tuple.to_list/1)

        {result, _} =
          Enum.reduce(pairs, "", fn [number, operator], acc ->
            "(#{acc} #{number}) #{operator}"
          end)
          |> Code.eval_string()

        result
      end)

    Enum.find(possibilities, fn possibility ->
      possibility == answer
    end)
  end

  defp get_operator_list(length) do
    get_operator_list(length - 1, for(x <- ["*", "+"], do: [x]))
  end

  defp get_operator_list(0, acc), do: acc

  defp get_operator_list(length, acc) do
    get_operator_list(length - 1, for(x <- ["*", "+"], y <- acc, do: [x | y]))
  end

  @doc """
    iex> part2(AoC2024.Day07.Input.test_input())
    11387

    iex> part2(AoC2024.Day07.Input.input())
    424977609625985

  """
  def part2(input) do
    {part2s, part1s} =
      parse_input(input)
      |> Enum.map(fn line ->
        {line, evaluate_line(line)}
      end)
      |> Enum.split_with(fn {_line, evaluated} -> is_nil(evaluated) end)

    part1_sum = part1s |> Enum.map(fn {_, evaluated} -> evaluated end) |> Enum.sum() |> dbg

    part2_lines = part2s |> Enum.map(fn {line, _} -> line end)

    length = length(part2_lines)

    part2_tasks =
      part2_lines
      |> Enum.with_index()
      |> Enum.map(fn {line, index} ->
        Task.async(fn ->
          IO.inspect("starting line #{index} of #{length}: #{inspect(line)}")
          result = evaluate_line_2(line)
          IO.inspect("finished line #{index} of #{length}: #{inspect(result)}")
          result
        end)
      end)

    part2_sum =
      part2_tasks
      |> Task.await_many(:infinity)
      |> Enum.reject(&is_nil/1)
      |> Enum.sum()

    part1_sum + part2_sum
  end

  defp evaluate_line_2({answer, numbers}) do
    length = length(numbers)

    operators_chunks =
      get_operator_list_2(length - 1)
      |> Enum.map(fn list -> list ++ [""] end)
      |> Enum.filter(fn operator_list ->
        # We already know it doesn't work if there are no "||" operators
        "||" in operator_list
      end)
      |> Enum.chunk_every(1000)

    possibility_tasks =
      Enum.map(operators_chunks, fn operator_chunk ->
        Task.async(fn ->
          Enum.map(operator_chunk, fn operator_list ->
            pairs =
              Enum.zip(numbers, operator_list) |> Enum.map(&Tuple.to_list/1)

            {result, _} =
              Enum.reduce_while(pairs, "", fn [number, operator], acc ->
                {result, _} =
                  if String.ends_with?(acc, " ||") do
                    acc = String.trim_trailing(acc, " ||")
                    {String.to_integer("#{acc}#{number}"), nil}
                  else
                    Code.eval_string("#{acc} #{number}")
                  end

                if result > answer do
                  {:halt, nil}
                else
                  {:cont, "#{result} #{operator}"}
                end
              end)
              |> Code.eval_string()

            result
          end)
        end)
      end)

    possibilities =
      possibility_tasks
      |> Task.await_many(:infinity)
      |> List.flatten()

    Enum.find(possibilities, fn possibility ->
      possibility == answer
    end)
  end

  defp get_operator_list_2(length) do
    get_operator_list_2(length - 1, for(x <- ["*", "+", "||"], do: [x]))
  end

  defp get_operator_list_2(0, acc), do: acc

  defp get_operator_list_2(length, acc) do
    get_operator_list_2(length - 1, for(x <- ["*", "+", "||"], y <- acc, do: [x | y]))
  end
end
