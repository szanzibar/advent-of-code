defmodule AoC.Day04.Test do
  use ExUnit.Case
  require Logger

  @tag :d4p1
  test "example: part1" do
    assert AoC.Day04.part1("test_input") == 4512
  end

  @tag :d4p1
  test "real data: part1" do
    results = AoC.Day04.part1("input")
    Logger.info("part 1 results: #{results}")
    assert results == 2745
  end

  @tag :d4p2
  test "example: part2" do
    assert AoC.Day04.part2("test_input") == 1924
  end

  @tag :d4p2
  test "real data: part2" do
    results = AoC.Day04.part2("input")
    Logger.info("part 2 results: #{results}")
    assert is_integer(results)
  end
end
