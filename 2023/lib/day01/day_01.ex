defmodule AoC2023.Day01 do
  def get_input(file) do
    File.read!(Path.join(__DIR__, file))
    |> String.split("\n")
  end

  @doc """
    iex> part1("test_input")
    142

    iex> part1("input")
    54916

  """
  def part1(input_file) do
    get_input(input_file)
    |> Enum.reduce(0, fn line, acc ->
      Regex.scan(~r/\d/, line)
      |> List.flatten()
      |> sum_first_last(acc)
    end)
  end

  @doc """
    iex> part2("test_input_p2")
    281

    iex> part2("input")
    54728

  """
  def part2(input_file) do
    get_input(input_file)
    |> Enum.reduce(0, fn line, acc ->
      Regex.scan(
        ~r/(?=(\d|one|two|three|four|five|six|seven|eight|nine))/,
        line,
        capture: :all_but_first
      )
      |> List.flatten()
      |> Enum.map(&clean_numbers/1)
      |> sum_first_last(acc)
    end)
  end

  defp sum_first_last(num_list, acc) do
    {num, _} =
      [Enum.at(num_list, 0), Enum.at(num_list, -1)]
      |> Enum.join()
      |> Integer.parse()

    num + acc
  end

  defp clean_numbers(string) do
    string
    |> String.replace("one", "1")
    |> String.replace("two", "2")
    |> String.replace("three", "3")
    |> String.replace("four", "4")
    |> String.replace("five", "5")
    |> String.replace("six", "6")
    |> String.replace("seven", "7")
    |> String.replace("eight", "8")
    |> String.replace("nine", "9")
  end
end
