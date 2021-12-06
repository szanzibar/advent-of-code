defmodule AoC.Day06.Test do
  use ExUnit.Case
  require Logger
  import AoC.Day06

  @tag :d6p1
  test "example: part1" do
    assert part1("test_input") == 5934
  end

  @tag :d6p1
  test "real data: part1" do
    results = part1("input")
    Logger.info("part 1 results: #{results}")
    assert is_integer(results)
  end

  @tag :d6p2
  test "example: part2" do
    assert part2("test_input") == 12
  end

  @tag :d6p2
  test "real data: part2" do
    results = part2("input")
    Logger.info("part 2 results: #{results}")
    assert is_integer(results)
  end
end
