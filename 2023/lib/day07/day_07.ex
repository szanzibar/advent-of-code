defmodule AoC2023.Day07 do
  @card_values_1 ~w{A K Q J T 9 8 7 6 5 4 3 2} |> Enum.reverse() |> Enum.with_index() |> Map.new()
  @card_values_2 ~w{A K Q T 9 8 7 6 5 4 3 2 J} |> Enum.reverse() |> Enum.with_index() |> Map.new()

  def get_input(file) do
    File.read!(Path.join(__DIR__, file))
    |> String.split("\n")
    |> Enum.map(fn line ->
      [hand, bid] = line |> String.split(" ")
      {hand, String.to_integer(bid)}
    end)
  end

  @doc """
    iex> part1("test_input")
    6440

    iex> part1("input")
    249204891

  """
  def part1(input_file), do: partN(input_file, 1)

  @doc """
    iex> part2("test_input")
    5905

    iex> part2("input")
    249666369
  """
  def part2(input_file), do: partN(input_file, 2)

  defp partN(input_file, part) do
    get_input(input_file)
    |> Enum.sort_by(&map_cards(&1, part))
    |> Enum.with_index()
    |> Enum.reduce(0, fn {{_hand, bid}, rank}, acc ->
      (rank + 1) * bid + acc
    end)
  end

  def map_cards({hand, _}, part) do
    value = get_hand_strength(hand, part)

    key = if part == 1, do: @card_values_1, else: @card_values_2
    tie_breaker = String.codepoints(hand) |> Enum.map(fn card -> Map.fetch!(key, card) end)

    [value | tie_breaker]
  end

  def get_hand_strength("JJJJJ", _), do: 6

  def get_hand_strength(hand, part) do
    cards = String.codepoints(hand)
    unique_card_count = cards |> Enum.uniq() |> Enum.count()

    if part == 2 && String.contains?(hand, "J") do
      {jokers, non_jokers} = cards |> Enum.split_with(fn c -> c == "J" end)

      {_max_card, max_card_frequency} =
        non_jokers |> Enum.frequencies() |> Enum.max_by(fn {_card, num} -> num end)

      {unique_card_count - 1, max_card_frequency + Enum.count(jokers)}
    else
      {_max_card, highest_card_frequency} =
        cards |> Enum.frequencies() |> Enum.max_by(fn {_card, num} -> num end)

      {unique_card_count, highest_card_frequency}
    end
    |> get_hand_strength()
  end

  @doc """
  takes {unique_card_count, highest_card_frequency} and returns hand strength
  examples:
  {2, 4} -> 2 unique cards, 1 card occurs 4 times, (4 of a kind)
  {3, 2} -> 3 unique cards, max of 2 each, 2 pairs
  """
  def get_hand_strength({1, _}), do: 6
  def get_hand_strength({2, 4}), do: 5
  def get_hand_strength({2, _}), do: 4
  def get_hand_strength({3, 3}), do: 3
  def get_hand_strength({3, _}), do: 2
  def get_hand_strength({4, _}), do: 1
  def get_hand_strength({5, _}), do: 0
end
