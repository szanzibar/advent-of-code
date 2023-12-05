defmodule AoC2023.Day05 do
  def get_input(file) do
    [seeds | maps] = File.read!(Path.join(__DIR__, file)) |> String.split("\n\n")

    seeds =
      seeds
      |> String.split(": ")
      |> Enum.at(-1)
      |> String.split(" ")
      |> Enum.map(&String.to_integer/1)

    maps =
      maps
      |> Enum.map(fn map ->
        map
        |> String.split("\n")
        |> Enum.drop(1)
        |> Enum.map(fn line ->
          [dest_start, source_start, length] =
            String.split(line, " ") |> Enum.map(&String.to_integer/1)

          {dest_start, Range.new(source_start, source_start + length - 1)}
        end)
      end)

    {seeds, maps}
  end

  @doc """
    iex> part1_original("test_input")
    35

    iex> part1_original("input")
    403695602

  """
  def part1_original(input_file) do
    {seeds, maps} = get_input(input_file)

    seeds
    |> Enum.map(fn seed ->
      map_number(seed, maps)
    end)
    |> Enum.min()
  end

  defp map_number(number, []), do: number

  defp map_number(number, [map | maps]) do
    map
    |> Enum.find_value(fn range ->
      number_in_range(range, number)
    end)
    |> case do
      nil -> number
      mapped_number -> mapped_number
    end
    |> map_number(maps)
  end

  defp number_in_range({dest_start, source_range}, number) do
    if Enum.member?(source_range, number) do
      number - source_range.first + dest_start
    else
      nil
    end
  end

  @doc """
    iex> part1("test_input")
    35

    iex> part1("input")
    403695602

  """
  def part1(input_file) do
    {seeds, maps} = get_input(input_file)

    seeds
    |> Enum.flat_map(fn seed ->
      Range.new(seed, seed) |> map_range(maps)
    end)
    |> Enum.min()
  end

  @doc """
    iex> part2("test_input")
    46

    iex> part2("input")
    219529182
  """
  def part2(input_file) do
    {seeds, maps} = get_input(input_file)

    ranges =
      seeds
      |> Enum.chunk_every(2)
      |> Enum.flat_map(fn [start, length] ->
        # split each range a bunch
        Range.new(start, start + length - 1)
        |> split_range()
        |> Enum.flat_map(&split_range/1)
        |> Enum.flat_map(&split_range/1)
      end)

    IO.inspect(length(ranges), label: "batches")

    ranges
    |> Stream.with_index()
    |> Stream.map(fn {seed_range, index} ->
      {time, results} =
        :timer.tc(
          fn ->
            map_range(seed_range, maps)
            |> Enum.min()
          end,
          :millisecond
        )

      results |> IO.inspect(label: "finished batch #{index} in #{time} ms. result")
    end)
    |> Enum.min()
  end

  defp map_range(range, []), do: range

  defp map_range(seed_range, [map_ranges | maps]) do
    {found, not_found} =
      map_ranges
      |> Enum.reduce({[], [seed_range]}, fn map_range, {found_ranges, acc_seed_ranges} ->
        {found, not_found} =
          Stream.flat_map(acc_seed_ranges, fn acc_seed_range ->
            seed_range_in_range(map_range, acc_seed_range)
          end)
          |> Enum.split_with(fn {found, _} -> found end)

        not_found = not_found |> Enum.map(fn {_, range} -> range end)

        {found ++ found_ranges, not_found}
      end)

    found
    |> Stream.map(fn {_, range} -> range end)
    |> Stream.concat(not_found)
    |> Stream.flat_map(fn new_seed_range -> map_range(new_seed_range, maps) end)
  end

  @doc """
  shifts all parts of seed_range that are in source_range, by dest_start amount
  """
  @spec seed_range_in_range({integer(), Range.t()}, Range.t()) :: [{true | false, Range.t()}]
  def seed_range_in_range({dest_start, source_range}, seed_range) do
    cond do
      seed_range.first in source_range && seed_range.last in source_range ->
        [
          {true,
           Range.new(
             seed_range.first - source_range.first + dest_start,
             seed_range.last - source_range.first + dest_start
           )}
        ]

      seed_range.first < source_range.first && seed_range.last > source_range.last ->
        {before, inside_and_after} =
          Range.split(seed_range, source_range.first - seed_range.first)

        {inside, after_source} =
          Range.split(inside_and_after, source_range.last - inside_and_after.first + 1)

        [
          seed_range_in_range({dest_start, source_range}, before),
          {true, Range.shift(inside, -source_range.first + dest_start)},
          seed_range_in_range({dest_start, source_range}, after_source)
        ]

      seed_range.first in source_range ->
        {first, last} = Range.split(seed_range, source_range.last - seed_range.first + 1)

        [
          {true, Range.shift(first, -source_range.first + dest_start)},
          seed_range_in_range({dest_start, source_range}, last)
        ]

      seed_range.last in source_range ->
        {first, last} = Range.split(seed_range, source_range.first - seed_range.first)

        [
          seed_range_in_range({dest_start, source_range}, first),
          {true, Range.shift(last, -source_range.first + dest_start)}
        ]

      true ->
        [{false, seed_range}]
    end
    |> List.flatten()
  end

  defp split_range(range) do
    size = Range.size(range)

    if size > 3 do
      {r1, r2} = Range.split(range, Integer.floor_div(size, 2))
      [r1, r2]
    else
      [range]
    end
  end
end
