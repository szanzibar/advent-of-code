defmodule AoC2022.Day02 do
  alias AoC2022.Utils

  def get_input(file) do
    File.read!(Path.join(__DIR__, file))
    |> String.split("\n")
    |> Enum.map(fn round ->
      String.split(round, " ") |> List.to_tuple()
    end)
  end

  @doc """
      iex> part1("test_input")
      15

      iex> part1("input")
      12679

  """
  def part1(input_file) do
    get_input(input_file)
    |> Enum.map(&outcome/1)
    |> Enum.map(fn {_, points} -> points end)
    |> Enum.sum()
  end

  defp outcome({"A", "X"}), do: {:draw, 4}
  defp outcome({"A", "Y"}), do: {:win, 8}
  defp outcome({"A", "Z"}), do: {:loss, 3}
  defp outcome({"B", "X"}), do: {:loss, 1}
  defp outcome({"B", "Y"}), do: {:draw, 5}
  defp outcome({"B", "Z"}), do: {:win, 9}
  defp outcome({"C", "X"}), do: {:win, 7}
  defp outcome({"C", "Y"}), do: {:loss, 2}
  defp outcome({"C", "Z"}), do: {:draw, 6}

  @doc """
      iex> part2("test_input")
      12

      iex> part2("input")
      14470

  """
  def part2(input_file) do
    get_input(input_file)
    |> Enum.map(&outcome2/1)
    |> Enum.map(fn {_, points} -> points end)
    |> Enum.sum()
  end

  defp outcome2({"A", "X"}), do: {:loss, 3}
  defp outcome2({"A", "Y"}), do: {:draw, 4}
  defp outcome2({"A", "Z"}), do: {:win, 8}
  defp outcome2({"B", "X"}), do: {:loss, 1}
  defp outcome2({"B", "Y"}), do: {:draw, 5}
  defp outcome2({"B", "Z"}), do: {:win, 9}
  defp outcome2({"C", "X"}), do: {:loss, 2}
  defp outcome2({"C", "Y"}), do: {:draw, 6}
  defp outcome2({"C", "Z"}), do: {:win, 7}
end
