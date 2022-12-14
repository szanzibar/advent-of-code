defmodule AoC2022.Day09 do
  def get_input(file) do
    File.read!(Path.join(__DIR__, file))
    |> String.split("\n")
    |> Enum.map(fn instruction ->
      String.split(instruction, " ")
      |> then(fn [dir, amount] ->
        {dir, String.to_integer(amount)}
      end)
    end)
  end

  @doc """
      iex> part1("test_input")
      13

      iex> part1("input")
      6018

  """
  def part1(input_file) do
    get_input(input_file)
    |> move_head({[{0, 0}, {0, 0}], %{{0, 0} => "#"}})
    |> Enum.uniq()
    |> Enum.count()
  end

  def move_head([], {_rope, grid}), do: grid

  def move_head([{direction, amount} | moves], {_rope, _grid} = acc) do
    new_acc =
      for _ <- 1..amount, reduce: acc do
        acc ->
          {rope, grid} = acc
          move_head_1(direction, rope, grid)
      end

    move_head(moves, new_acc)
  end

  def get_direction_change("U"), do: {0, 1}
  def get_direction_change("D"), do: {0, -1}
  def get_direction_change("L"), do: {-1, 0}
  def get_direction_change("R"), do: {1, 0}

  def move_head_1(direction, [{x, y} | tail], grid) do
    {dx, dy} = get_direction_change(direction)
    new_head = {x + dx, y + dy}
    move_tail_1([new_head | tail], [new_head], grid)
  end

  def get_tail_change(h_val, t_val) do
    case h_val - t_val do
      d when d > 1 -> 1
      d when d < -1 -> -1
      _ -> 0
    end
  end

  def move_tail_1([_head | []], [tail | _] = rope, grid) do
    updated_grid = Map.put(grid, tail, "#")
    {Enum.reverse(rope), updated_grid}
  end

  def move_tail_1([{hx, hy}, {tx, ty} | tail], moved_rope, grid) do
    head_dx = abs(hx - tx)
    head_dy = abs(hy - ty)

    tail_position =
      if head_dx == 0 || head_dy == 0 || head_dx == head_dy do
        {tx + get_tail_change(hx, tx), ty + get_tail_change(hy, ty)}
      else
        if head_dx > head_dy do
          {tx + get_tail_change(hx, tx), hy}
        else
          {hx, ty + get_tail_change(hy, ty)}
        end
      end

    move_tail_1([tail_position | tail], [tail_position | moved_rope], grid)
  end

  @doc """
      iex> part2("test_input")
      1

      iex> part2("test_2_input")
      36

      iex> part2("input")
      2619

  """
  def part2(input_file) do
    get_input(input_file)
    |> move_head(
      {[{0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}],
       %{{0, 0} => "#"}}
    )
    |> Enum.uniq()
    |> Enum.count()
  end
end
