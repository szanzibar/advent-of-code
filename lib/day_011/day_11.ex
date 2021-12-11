defmodule AoC.Day11 do
  def get_input(file) do
    File.read!(Path.join(__DIR__, file))
    |> String.split("\n", trim: true)
    |> Enum.map(
      &(String.graphemes(&1)
        |> Enum.map(fn s -> String.to_integer(s) end)
        |> Enum.with_index())
    )
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, x} ->
      Enum.map(row, fn {num, y} ->
        %{[x, y] => num}
      end)
    end)
    |> Enum.reduce(%{}, &Map.merge(&1, &2))
  end

  def part1(input) do
    get_input(input)
    |> step({0, 100})
  end

  defp step(grid, step \\ {0, -1}, grid \\ {0, 0})
  defp step(_grid, {step, _total_steps}, {_total_flashes, 100}), do: step

  defp step(_grid, {step, total_steps}, {total_flashes, _new_flashes}) when step == total_steps,
    do: total_flashes

  defp step(grid, {step, total_steps}, {flashes, _}) do
    flashed =
      grid
      |> add_1()
      |> flash(nil)

    new_flashes = Enum.count(flashed, fn {_k, v} -> v == "flashed" end)

    reset_flashed(flashed)
    |> step({step + 1, total_steps}, {flashes + new_flashes, new_flashes})
  end

  defp add_1(grid), do: Enum.map(grid, fn {k, v} -> {k, v + 1} end) |> Enum.into(%{})

  defp reset_flashed(grid) do
    Enum.map(grid, fn {k, v} ->
      case v == "flashed" do
        true -> {k, 0}
        false -> {k, v}
      end
    end)
    |> Enum.into(%{})
  end

  defp flash(grid, previous_grid) when grid == previous_grid, do: grid

  defp flash(grid, _) do
    Enum.map(grid, fn {[x, y], v} ->
      case grid[[x, y]] > 9 do
        true ->
          {[x, y], "flashed"}

        false ->
          neighbors =
            for x1 <- -1..1, y1 <- -1..1 do
              val = grid[[x + x1, y + y1]]

              case is_number(val) && val > 9 do
                true -> 1
                false -> 0
              end
            end
            |> Enum.sum()

          {[x, y], v + neighbors}
      end
    end)
    |> Enum.into(%{})
    |> flash(grid)
  end

  def part2(input) do
    get_input(input)
    |> step()
  end
end
