defmodule AoC.Day04 do
  defp get_input(file) do
    File.read!(Path.join(__DIR__, file))
    |> String.split("\n\n", trim: true)
  end

  defp parse_boards(read_input) do
    split_boards =
      Enum.map(read_input, fn board_string ->
        String.split(board_string, "\n", trim: true)
        |> Enum.map(fn row ->
          String.split(row, " ", trim: true) |> Enum.with_index()
        end)
        |> Enum.with_index()
      end)

    parsed_boards =
      Enum.map(split_boards, fn board ->
        Enum.flat_map(board, fn {row, row_index} ->
          Enum.map(row, fn {value, col_index} ->
            %{row: row_index, col: col_index, value: value, called: false}
          end)
        end)
      end)

    parsed_boards
  end

  def part1(input), do: bingo(input, true)
  def part2(input), do: bingo(input, false)

  def bingo(input, win?) do
    [draw_order | board_input] = get_input(input)
    draw_order = String.split(draw_order, ",", trim: true)
    boards = parse_boards(board_input)

    {final_board, final_number} = draw_numbers(draw_order, boards, win?)

    winning_sum =
      final_board
      |> Enum.filter(&(&1.called == false))
      |> Enum.map(&String.to_integer(&1.value))
      |> Enum.sum()

    final_number * winning_sum
  end

  defp draw_numbers([], boards, _win?), do: boards

  defp draw_numbers([called_number | tail], boards, win?) do
    updated_boards =
      Enum.map(boards, fn board ->
        Enum.map(board, fn cell ->
          if cell.value == called_number do
            Map.replace(cell, :called, true)
          else
            cell
          end
        end)
      end)

    final_board = final_board?(updated_boards, win?)

    case final_board do
      [winner | []] when win? == true ->
        {winner, String.to_integer(called_number)}

      [winner | []] when win? == false ->
        draw_numbers(tail, [winner], true)

      _ ->
        draw_numbers(tail, updated_boards, win?)
    end
  end

  defp final_board?(boards, win?) do
    Enum.filter(boards, fn board ->
      winning_board? =
        for n <- 0..4 do
          Enum.filter(board, &(&1.row == n))
          |> Enum.all?(&(&1.called == true)) ||
            Enum.filter(board, &(&1.col == n))
            |> Enum.all?(&(&1.called == true))
        end
        |> Enum.any?()

      case win? do
        true -> winning_board?
        false -> winning_board? |> Kernel.not()
      end
    end)
  end
end
