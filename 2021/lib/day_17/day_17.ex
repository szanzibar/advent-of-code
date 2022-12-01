defmodule AoC.Day17 do
  def get_input(file) do
    input = File.read!(Path.join(__DIR__, file))

    Regex.run(~r/x=(\S+)\.\.(\S+), y=(\S+)\.\.(\S+)/, input, capture: :all_but_first)
    |> Enum.map(&String.to_integer/1)
  end

  def part1(input) do
    [x0, x1, y0, y1] = get_input(input)

    velocities =
      for x <- 0..x1, y <- -abs(y0)..abs(y0) do
        {x, y}
      end

    velocities |> Enum.count() |> IO.inspect(label: "possibility count")

    Enum.map(velocities, fn velocity ->
      step(velocity, [x0, x1, y0, y1])
    end)
    |> Enum.filter(fn {hit?, _path} ->
      hit? == true
    end)
    |> Enum.map(fn {_true, path} ->
      Enum.max_by(path, fn {_x, y} ->
        y
      end)
    end)
    |> Enum.map(fn {_x, y} -> y end)
    |> Enum.max()
    |> IO.inspect(label: "max")
  end

  defp step(velocity, goal, position \\ {0, 0}, acc \\ [])

  defp step(_velocity, [_x0, x1, y0, _y1] = _goal, {x, y} = _position, acc)
       when x > x1 or y < y0 do
    {false, acc}
  end

  defp step(_velocity, [x0, x1, y0, y1] = _goal, {x, y} = _position, acc)
       when x >= x0 and x <= x1 and y >= y0 and y <= y1 do
    {true, acc}
  end

  defp step({dx, dy} = _velocity, [x0, x1, y0, y1] = _goal, {x, y} = _position, acc) do
    new_position = {dx + x, dy + y}

    new_dx =
      case dx do
        dx when dx > 0 -> dx - 1
        0 -> 0
        dx when dx < 0 -> dx + 1
      end

    step({new_dx, dy - 1}, [x0, x1, y0, y1], new_position, [
      new_position | acc
    ])
  end

  def part2(input) do
    [x0, x1, y0, y1] = get_input(input)

    velocities =
      for x <- 0..x1, y <- -abs(y0)..abs(y0) do
        {x, y}
      end

    velocities |> Enum.count() |> IO.inspect(label: "possibility count")

    Enum.map(velocities, fn velocity ->
      step(velocity, [x0, x1, y0, y1])
    end)
    |> Enum.filter(fn {hit?, _path} ->
      hit? == true
    end)
    |> Enum.count()
    |> IO.inspect(label: "hits")
  end
end
