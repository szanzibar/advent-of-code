defmodule AoC2023.Day02 do
  def get_input(file) do
    File.read!(Path.join(__DIR__, file))
    |> String.split("\n")
  end

  defp get_max_seen(input) do
    input
    |> Enum.map(fn line ->
      line
      |> String.split(": ")
      |> Enum.at(-1)
      |> String.split("; ")
      |> Enum.map(fn set ->
        set
        |> String.split(", ")
        |> Enum.map(fn num_color ->
          num_color
          |> String.split(" ")
          |> case do
            [num, "blue"] -> {:blue, parse_num(num)}
            [num, "green"] -> {:green, parse_num(num)}
            [num, "red"] -> {:red, parse_num(num)}
          end
        end)
        |> Map.new()
      end)
      |> Enum.reduce(fn set, acc ->
        Map.merge(set, acc, fn _k, v1, v2 ->
          if v1 > v2, do: v1, else: v2
        end)
      end)
    end)
  end

  @doc """
    iex> part1("test_input")
    8

    iex> part1("input")
    2149

  """
  def part1(input_file) do
    test_case = %{red: 12, green: 13, blue: 14}

    get_input(input_file)
    |> get_max_seen
    |> Enum.with_index()
    |> Enum.reduce(0, fn {set, index}, acc ->
      if set.green > test_case.green || set.red > test_case.red || set.blue > test_case.blue do
        acc
      else
        index + 1 + acc
      end
    end)
  end

  defp parse_num(num) do
    {num, _} = Integer.parse(num)
    num
  end

  @doc """
    iex> part2("test_input")
    2286

    iex> part2("input")
    71274

  """
  def part2(input_file) do
    get_input(input_file)
    |> get_max_seen
    |> Enum.map(fn %{green: g, red: r, blue: b} ->
      g * r * b
    end)
    |> Enum.sum()
  end
end
