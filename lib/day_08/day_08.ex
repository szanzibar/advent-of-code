defmodule AoC.Day08 do
  defp get_input(file) do
    File.read!(Path.join(__DIR__, file))
    |> String.split("\n", trim: true)
    |> Enum.map(fn l ->
      String.split(l, "|", trim: true)
      |> Enum.map(fn s ->
        String.split(s, " ", trim: true)
        |> Enum.map(&(String.to_charlist(&1) |> Enum.sort()))
      end)
    end)
  end

  def part1(input) do
    get_input(input)
    |> Enum.reduce(0, fn [_pattern, output], acc ->
      Enum.count(
        Enum.filter(output, fn segment ->
          length = Enum.count(segment)
          length <= 4 || length == 7
        end)
      ) + acc
    end)
  end

  def part2(input) do
    get_input(input)
    |> Enum.reduce(0, fn [pattern, output], acc ->
      key = build_letter_key(pattern)

      Integer.undigits(Enum.map(output, &key[&1])) + acc
    end)
  end

  defp build_letter_key(pattern) do
    # letter counts give us 3 unique values: 6 top left, 4 bottom left, and 9 bottom right
    letter_counts = get_letter_counts(pattern)

    key =
      %{}
      |> Map.put(1, Enum.find(pattern, &(Enum.count(&1) == 2)))
      |> Map.put(7, Enum.find(pattern, &(Enum.count(&1) == 3)))
      |> Map.put(4, Enum.find(pattern, &(Enum.count(&1) == 4)))
      |> Map.put(8, Enum.find(pattern, &(Enum.count(&1) == 7)))

    key =
      key
      |> Map.put(9, key[8] -- letter_counts[4])
      |> Map.put(2, (key[8] -- letter_counts[9]) -- letter_counts[6])
      |> Map.put(6, (key[8] -- key[1]) ++ letter_counts[9])
      |> Map.put(
        0,
        ((((key[8] -- key[4]) ++ key[7]) ++ letter_counts[6]) ++ letter_counts[4]) |> Enum.uniq()
      )

    key =
      key
      |> Map.put(3, key[9] -- letter_counts[6])
      |> Map.put(5, key[6] -- letter_counts[4])

    Enum.reduce(key, %{}, fn {k, v}, acc -> Map.merge(%{Enum.sort(v) => k}, acc) end)
  end

  defp get_letter_counts(pattern) do
    Enum.reduce(pattern, &(&1 ++ &2))
    |> Enum.sort()
    |> Enum.chunk_by(& &1)
    |> Enum.map(&%{Enum.count(&1) => Enum.uniq(&1)})
    |> Enum.reduce(&Map.merge(&1, &2))
  end
end
