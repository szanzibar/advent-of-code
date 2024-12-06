defmodule AoC2024.Day05 do
  @moduledoc """
  ohhhh man I spent like 95% of my time making my sort function go recursive
  because I thought it was going to be possible for weird nested greater_than/less_than rules
  but at the very end I commented out the nested stuff and I still get the right answers 🤦

  Another reminder to just take the simplest possible path first. Don't preoptimize!!!!

  for posterity: this cond was originally in the sort function:

  ...

  rights = Map.get(rule_map, left, [])

  cond do
    right in rights -> true

    go_deeper? ->
      false_or_unknown =
        rights
        |> Enum.map(fn known_greater_than ->
          # check if all the numbers that we know are greater than left are still less than right
          {known_greater_than, rule_sorter(known_greater_than, right, rule_map, false)}
        end)
        |> Enum.reject(fn {_known_greater_than, check?} -> check? end)

      if false_or_unknown == [] do
        true
      else
        false_or_unknown
        |> Enum.map(fn {known_greater_than, _} ->
          rule_sorter(known_greater_than, right, rule_map, true)
        end)
        end
  end
  """

  def parse_input(input) do
    [rules, page_list] =
      input
      |> String.trim()
      |> String.split("\n\n")
      |> Enum.map(fn section ->
        section
        |> String.split("\n")
        |> Enum.map(fn rule -> String.split(rule, [",", "|"]) end)
      end)

    [create_rule_map(rules), page_list]
  end

  defp create_rule_map(rules) do
    Enum.group_by(rules, &List.first(&1), &List.last(&1))
  end

  @doc """
    iex> part1(AoC2024.Day05.Input.test_input())
    143

    iex> part1(AoC2024.Day05.Input.input())
    4774

  """
  def part1(input) do
    [rule_map, page_list] = parse_input(input)

    Enum.zip(page_list, sort_page_list(page_list, rule_map))
    |> Enum.filter(fn {un_sorted, sorted} -> un_sorted == sorted end)
    |> Enum.map(fn {valid_pages, _} -> valid_pages end)
    |> middle_sum()
  end

  @doc """
    iex> part2(AoC2024.Day05.Input.test_input())
    123

    iex> part2(AoC2024.Day05.Input.input())
    6004

  """
  def part2(input) do
    [rule_map, page_list] = parse_input(input)

    Enum.zip(page_list, sort_page_list(page_list, rule_map))
    |> Enum.reject(fn {un_sorted, sorted} -> un_sorted == sorted end)
    |> Enum.map(fn {_, sorted_pages} -> sorted_pages end)
    |> middle_sum()
  end

  defp sort_page_list(page_list, rule_map) do
    page_list
    |> Enum.map(fn pages ->
      Enum.sort(pages, &rule_sorter(&1, &2, rule_map))
    end)
  end

  defp rule_sorter(left, right, rule_map) do
    # true if left is before right

    # I STILL CAN'T BELIEVE THIS IS ALL THAT'S NEEDED FOR VALID RULES
    # THIS USED TO BE SO MUCH MORE COMPLICATED!!!!!
    right in Map.get(rule_map, left, [])
  end

  defp middle_sum(page_lists) do
    page_lists
    |> Enum.map(fn valid_pages ->
      Enum.at(valid_pages, Integer.floor_div(Enum.count(valid_pages), 2)) |> String.to_integer()
    end)
    |> Enum.sum()
  end
end
