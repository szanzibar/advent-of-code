defmodule AoC2023.Day06 do
  def get_input(file, part) do
    merge_part_2 = fn line ->
      if part == 2 do
        [line |> Enum.join()]
      else
        line
      end
    end

    File.read!(Path.join(__DIR__, file))
    |> String.split("\n")
    |> Enum.map(fn line ->
      line
      |> String.split([": ", " "], trim: true)
      |> Enum.drop(1)
      |> merge_part_2.()
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.zip()
  end

  def calc_distance(hold_time, race_time) do
    travel_time = race_time - hold_time
    speed = hold_time
    speed * travel_time
  end

  def get_num_of_possible_wins({race_time, distance}) do
    [first_win, last_win] =
      [
        Task.async(fn ->
          Range.new(1, race_time)
          |> Enum.find(fn hold_time ->
            calc_distance(hold_time, race_time) > distance
          end)
        end),
        Task.async(fn ->
          Range.new(race_time, 1)
          |> Enum.find(fn hold_time ->
            calc_distance(hold_time, race_time) > distance
          end)
        end)
      ]
      |> Task.await_many()

    first_win..last_win |> Enum.count()
  end

  @doc """
    iex> part1("test_input")
    288

    iex> part1("input")
    608902

  """
  def part1(input_file) do
    get_input(input_file, 1)
    |> Enum.map(&get_num_of_possible_wins_fast/1)
    |> Enum.product()
  end

  @doc """
    iex> part2("test_input")
    71503

    iex> part2("input")
    46173809

  """
  def part2(input_file) do
    get_input(input_file, 2)
    |> Enum.map(&get_num_of_possible_wins_fast/1)
    |> Enum.at(0)
  end

  def get_num_of_possible_wins_fast({race_time, distance}) do
    range = Range.new(1, race_time)

    first_win =
      range
      |> b_tree_find(fn hold_time ->
        calc_distance(hold_time, race_time) > distance
      end)

    last_win = race_time - first_win
    last_win - first_win + 1
  end

  def b_tree_find(list, func), do: b_tree_find(list, {1, Enum.count(list)}, func)
  def b_tree_find(_, {first, last}, _) when first == last, do: first + 1

  def b_tree_find(list, {first, last}, func) do
    middle = Integer.floor_div(last - first, 2) + first
    middle_value = Enum.at(list, middle)

    new_coord_range =
      if func.(middle_value) do
        {first, middle}
      else
        {1 + middle, last}
      end

    b_tree_find(list, new_coord_range, func)
  end
end
