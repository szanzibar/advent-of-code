defmodule AoC2023.Day04 do
  def get_input(file) do
    File.read!(Path.join(__DIR__, file))
    |> String.split("\n")
    |> Enum.map(fn line ->
      line
      |> String.split(": ")
      |> Enum.at(-1)
      |> String.split(" | ")
      |> Enum.map(fn number_list ->
        String.split(number_list, " ", trim: true)
        |> MapSet.new()
      end)
      |> List.to_tuple()
    end)
  end

  @doc """
    iex> part1("test_input")
    13

    iex> part1("input")
    21919

  """
  def part1(input_file) do
    get_input(input_file)
    |> Enum.map(fn {winning_numbers, my_numbers} ->
      MapSet.intersection(winning_numbers, my_numbers)
      |> Enum.count()
      |> calculate_score
    end)
    |> Enum.sum()
  end

  defp calculate_score(0), do: 0
  defp calculate_score(wins), do: Integer.pow(2, wins - 1)

  @doc """
    iex> part2("test_input")
    30

    iex> part2("input")
    9881048

  """
  def part2(input_file) do
    starting_cards =
      get_input(input_file)
      |> Enum.map(fn {winning_numbers, my_numbers} ->
        MapSet.intersection(winning_numbers, my_numbers)
        |> Enum.count()
      end)
      |> Enum.with_index()
      |> Enum.map(fn {wins, num} -> {num + 1, {wins, 1}} end)
      |> Map.new()
      |> process_cards(1)
      |> Enum.map(fn {_card_num, {_wins, count}} -> count end)
      |> Enum.sum()
  end

  defp process_cards(cards, card_num) when card_num > map_size(cards), do: cards

  defp process_cards(cards, card_num) do
    {wins, count} = Map.fetch!(cards, card_num)

    new_cards =
      if wins > 0 do
        (card_num + 1)..(wins + card_num)
        |> Enum.reduce(cards, fn new_card_num, cards_acc ->
          {_, updated_map} =
            cards_acc
            |> Map.get_and_update!(new_card_num, fn {current_card_num, current_count} =
                                                      current_value ->
              {current_value, {current_card_num, count + current_count}}
            end)

          updated_map
        end)
      else
        cards
      end

    process_cards(new_cards, card_num + 1)
  end
end
