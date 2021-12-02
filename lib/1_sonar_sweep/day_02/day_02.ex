defmodule AoC.Day02 do
  defp get_movements(file) do
    File.read!(Path.join(__DIR__, file))
    |> String.split("\n", trim: true)
    |> Enum.map(fn command ->
      String.split(command)
      |> Enum.chunk_every(2)
      |> Map.new(fn [cmd, ammount] -> {String.to_atom(cmd), String.to_integer(ammount)} end)
    end)
  end

  def part1(file) do
    movements =
      get_movements(file)
      |> Enum.reduce(%{}, fn instruction, acc ->
        Map.merge(instruction, acc, fn _key, v1, v2 ->
          v1 + v2
        end)
      end)

    (movements.down - movements.up) * movements.forward
  end

  def part2(file) do
    movements = get_movements(file) |> IO.inspect()
    part2(movements, 0, 0, 0)
  end

  def part2([], _aim, position, depth) do
    depth * position
  end

  def part2([movement | tail], aim, position, depth) do
    case movement do
      %{down: d} ->
        part2(tail, aim + d, position, depth)

      %{up: u} ->
        part2(tail, aim - u, position, depth)

      %{forward: f} ->
        part2(tail, aim, position + f, depth + aim * f)
    end
  end
end
