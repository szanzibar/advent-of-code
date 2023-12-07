defmodule AoC2023.Day07 do
  @card_values ~w{A K Q J T 9 8 7 6 5 4 3 2} |> Enum.reverse() |> Enum.with_index() |> Map.new()
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
    # iex> part1("test_input")
    # 6440

    # iex> part1("input")
    # 249204891

  """
  def part1(input_file) do
    get_input(input_file)
    |> Enum.sort(&sort_cards/2)
    |> Enum.reverse()
    |> Enum.with_index()
    |> Enum.reduce(0, fn {{_hand, bid}, rank}, acc ->
      (rank + 1) * bid + acc
    end)
  end

  def sort_cards({left, _}, {right, _}) do
    left_value = get_hand_strength(left)
    right_value = get_hand_strength(right)

    cond do
      left_value > right_value ->
        true

      left_value < right_value ->
        false

      left_value == right_value ->
        compare_equivalent_hand(left, right)
    end
  end

  def compare_equivalent_hand(left, right) do
    left =
      String.codepoints(left)
      |> Enum.map(fn card -> Map.fetch!(@card_values, card) end)

    right =
      String.codepoints(right)
      |> Enum.map(fn card -> Map.fetch!(@card_values, card) end)

    left >= right
  end

  @doc """
  takes hand, returns hand type as integer strength
  high card         0
  one pair          1
  two pair          2
  three of a kind   3
  full house        4
  four of a kind    5
  five of a kind    6
  """
  def get_hand_strength(hand) do
    codepoints = String.codepoints(hand)
    unique_cards = codepoints |> Enum.uniq() |> Enum.count()
    groups = codepoints |> Enum.frequencies()

    case unique_cards do
      1 ->
        # 5 of a kind (all the same)
        6

      2 ->
        # 4 of a kind or full house
        if Enum.any?(groups, fn {_card, amount} -> amount == 4 end) do
          # 4 of a kind
          5
        else
          # full house
          4
        end

      3 ->
        # three of a kind or 2 pair
        if Enum.any?(groups, fn {_card, amount} -> amount == 3 end) do
          # 3 of a kind
          3
        else
          # 2 pair
          2
        end

      4 ->
        # one pair
        1

      5 ->
        # high pair
        0
    end
  end

  @doc """
    iex> part2("test_input")
    5905

    iex> part2("input")
    249666369
  """
  def part2(input_file) do
    get_input(input_file)
    |> Enum.sort(&sort_cards_2/2)
    |> Enum.reverse()
    |> Enum.with_index()
    |> Enum.reduce(0, fn {{_hand, bid}, rank}, acc ->
      (rank + 1) * bid + acc
    end)
  end

  def sort_cards_2({left, _}, {right, _}) do
    left_value =
      if String.contains?(left, "J"), do: get_hand_strength_2(left), else: get_hand_strength(left)

    right_value =
      if String.contains?(right, "J"),
        do: get_hand_strength_2(right),
        else: get_hand_strength(right)

    cond do
      left_value > right_value ->
        true

      left_value < right_value ->
        false

      left_value == right_value ->
        compare_equivalent_hand_2(left, right)
    end
  end

  def get_hand_strength_2("JJJJJ"), do: 6

  def get_hand_strength_2(hand) do
    codepoints = String.codepoints(hand)
    {jokers, cards} = codepoints |> Enum.split_with(fn c -> c == "J" end)
    groups = cards |> Enum.frequencies()
    {max_card, amount} = groups |> Enum.max_by(fn {_card, num} -> num end)
    jokered_groups = Map.put(groups, max_card, amount + Enum.count(jokers))

    unique_cards = map_size(jokered_groups)

    case unique_cards do
      1 ->
        # 5 of a kind (all the same)
        6

      2 ->
        # 4 of a kind or full house
        if Enum.any?(jokered_groups, fn {_card, amount} -> amount == 4 end) do
          # 4 of a kind
          5
        else
          # full house
          4
        end

      3 ->
        # three of a kind or 2 pair
        if Enum.any?(jokered_groups, fn {_card, amount} -> amount == 3 end) do
          # 3 of a kind
          3
        else
          # 2 pair
          2
        end

      4 ->
        # one pair
        1

      5 ->
        # high pair
        0
    end
  end

  def compare_equivalent_hand_2(left, right) do
    left =
      String.codepoints(left)
      |> Enum.map(fn card -> Map.fetch!(@card_values_2, card) end)

    right =
      String.codepoints(right)
      |> Enum.map(fn card -> Map.fetch!(@card_values_2, card) end)

    left >= right
  end
end
