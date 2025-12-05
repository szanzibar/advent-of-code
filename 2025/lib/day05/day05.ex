defmodule AoC2025.Day05 do
  def parse_input(input) do
    [ranges, ids] = input |> String.trim() |> String.split("\n\n")

    ranges =
      ranges
      |> String.split("\n")
      |> Enum.map(fn range ->
        [left, right] = String.split(range, "-") |> Enum.map(&String.to_integer/1)
        {left, right}
      end)

    ids = ids |> String.split("\n") |> Enum.map(&String.to_integer/1)

    {ranges, ids}
  end

  @doc """
    iex> part1(AoC2025.Day05.Input.test_input())
    3

    iex> part1(AoC2025.Day05.Input.input())
    529

  """
  def part1(input) do
    {ranges, ids} = parse_input(input)
    Enum.map(ids, fn id -> number_in_ranges?(id, ranges) end) |> Enum.count(& &1)
  end

  defp number_in_ranges?(number, ranges) do
    Enum.any?(ranges, &number_in_range?(number, &1))
  end

  defp number_in_range?(number, {left, right}) do
    number >= left && number <= right
  end

  @doc """
    iex> part2(AoC2025.Day05.Input.test_input())
    14

    iex> part2(AoC2025.Day05.Input.input())
    344260049617193
    # < 39513167677689

  """
  def part2(input) do
    {ranges, _ids} = parse_input(input)

    merge_ranges(Enum.sort(ranges))
    |> Enum.map(fn {left, right} -> right - left + 1 end)
    |> Enum.sum()
  end

  def merge_ranges([first_range | ranges]) do
    Enum.reduce(ranges, [first_range], fn {left, right}, merged_ranges ->
      # need to see if we can merge this range into any in the acc
      # check on each merged_range if we can merge in this current range
      {merged_results, new_merged_ranges} =
        Enum.map(merged_ranges, fn {merged_left, merged_right} ->
          cond do
            merged_right <= right && merged_right >= left ->
              {true, {merged_left, right}}

            right <= merged_right && right <= merged_left ->
              {true, {left, merged_right}}

            # completely replaced
            merged_right <= right && merged_left >= left ->
              {true, {right, left}}

            right <= merged_right && left >= merged_left ->
              {true, {merged_left, merged_right}}

            true ->
              {false, {merged_left, merged_right}}
          end
        end)
        |> Enum.unzip()

      merged? = Enum.any?(merged_results)

      if merged? do
        new_merged_ranges
      else
        [{left, right} | merged_ranges]
      end
    end)
  end
end
