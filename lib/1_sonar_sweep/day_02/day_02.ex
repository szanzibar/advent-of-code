defmodule AoC.Day02 do
  defp get_movements(file) do
    File.read!(Path.join(__DIR__, file))
    |> String.split("\n", trim: true)
    |> Enum.map(fn command ->
      String.split(command)
      |> Enum.chunk_every(2)
      |> Map.new(fn [cmd, ammount] -> {String.to_atom(cmd), String.to_integer(ammount)} end)
    end)
    |> Enum.reduce(%{}, fn instruction, acc ->
      Map.merge(instruction, acc, fn _key, v1, v2 ->
        v1 + v2
      end)
    end)
  end

  def part1(file) do
    movements = get_movements(file)
    (movements.down - movements.up) * movements.forward
  end
end
