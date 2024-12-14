defmodule AoC2024.Day14 do
  @moduledoc """
  More remembering math 🤔
  I started by trying to create linear equations
  but then I asked claude to help with the math.
  It helped me realize how simple the equation is since we are already given
  the rate of change for both X and Y
  """

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn line ->
      Regex.scan(~r/-?\d+/, line) |> List.flatten() |> Enum.map(&String.to_integer/1)
    end)
  end

  @doc """
    iex> part1(AoC2024.Day14.Input.test_input(), {11, 7})
    12

    iex> part1(AoC2024.Day14.Input.input(), {101, 103})
    228410028

  """
  def part1(input, grid_size) do
    robots = parse_input(input)

    moved_robots = move_robots(robots, grid_size, 100)

    group_quadrants(moved_robots, grid_size)
  end

  defp group_quadrants(robots, {max_width, max_height}) do
    center_x = Integer.floor_div(max_width, 2)
    center_y = Integer.floor_div(max_height, 2)

    robots
    # remove quadrant middles
    |> Enum.reject(fn {x, y} ->
      x == center_x || y == center_y
    end)
    |> Enum.group_by(&assign_quadrant(&1, {center_x, center_y}))
    |> Enum.map(fn {_quadrant, list} -> Enum.count(list) end)
    |> Enum.product()
  end

  defp assign_quadrant({x, y}, {center_x, center_y}) do
    cond do
      x < center_x and y < center_y -> 1
      x < center_x and y > center_y -> 2
      x > center_x and y < center_y -> 3
      x > center_x and y > center_y -> 4
    end
  end

  defp move_robots(robits, grid_size, count) do
    Enum.map(robits, &move_robot(&1, grid_size, count))
  end

  defp move_robot([x1, y1, dx, dy], {width, height}, iterations) do
    total_x = dx * iterations + x1
    total_y = dy * iterations + y1

    x = teleport(total_x, width)
    y = teleport(total_y, height)

    {x, y}
  end

  defp teleport(location, max) when location < 0 do
    teleport(location + max, max)
  end

  defp teleport(location, max) when location >= max do
    teleport(location - max, max)
  end

  defp teleport(location, _max), do: location

  @doc """
    iex> part2(AoC2024.Day14.Input.input(), {101, 103})
    8258

  """
  def part2(input, grid_size) do
    robots = parse_input(input)

    # Originally I tested from 0 to 10_000
    {_, iteration} =
      Enum.reduce(8000..8260, {0, 0}, fn i, {highest_so_far, iteration} ->
        robots = move_robots(robots, grid_size, i)
        neighbors = robots |> number_of_neighbors_touching()

        if neighbors > highest_so_far do
          IO.inspect("Found higher neighbor count: #{neighbors} at iteration: #{i}")
          print(robots, grid_size)
          {Enum.max([neighbors, highest_so_far]), i}
        else
          {highest_so_far, iteration}
        end
      end)

    iteration
  end

  defp number_of_neighbors_touching(robots) do
    map = Map.new(Enum.map(robots, &{&1, 1}))

    robots
    |> Enum.map(fn robot ->
      robot |> next_coords |> Enum.map(&Map.get(map, &1, 0)) |> Enum.sum()
    end)
    |> Enum.sum()
  end

  defp next_coords({row, col}) do
    [{-1, 0}, {0, 1}, {1, 0}, {0, -1}]
    |> Enum.map(fn {row_offset, col_offset} ->
      {row_offset + row, col_offset + col}
    end)
  end

  defp print(robots, {max_width, max_height}) do
    robots = Map.new(Enum.map(robots, &{&1, "#"}))

    spaces =
      Map.new(
        for x <- 0..(max_width - 1), y <- 0..(max_height - 1) do
          {{x, y}, "."}
        end
      )

    final = Map.merge(spaces, robots)

    Enum.sort_by(final, fn {coord, _} -> coord end)
    |> Enum.chunk_by(fn {{row, _col}, _} -> row end)
    |> Enum.map(fn row ->
      row
      |> Enum.map(fn {_coord, character} -> character end)
      |> Enum.join(" ")
      |> IO.inspect()
    end)
  end
end
