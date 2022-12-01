defmodule AoC.Day03.Test do
  use ExUnit.Case
  require Logger

  test "example: part1" do
    assert AoC.Day03.part1("test_input") == 198
  end

  test "real data: part1" do
    results = AoC.Day03.part1("input")
    Logger.info("part 1 results: #{results}")
    assert is_integer(results)
  end

  test "example: part2" do
    assert AoC.Day03.part2("test_input") == 230
  end

  test "real data: part2" do
    results = AoC.Day03.part2("input")
    Logger.info("part 2 results: #{results}")
    assert is_integer(results)
  end
end
