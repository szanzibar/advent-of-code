defmodule AoC.Day10.Test do
  use ExUnit.Case
  require Logger
  import AoC.Day10

  @tag :d10p1
  test "example: part1" do
    assert part1("test_input") == 26_397
  end

  @tag :d10p1real
  test "real data: part1" do
    results = part1("input")
    Logger.info("part 1 results: #{results}")
    assert results == 388_713
  end

  @tag :d10p2
  test "example: part2" do
    assert part2("test_input") == 288_957
  end

  @tag :d10p2real
  test "real data: part2" do
    results = part2("input")
    Logger.info("part 2 results: #{results}")
    assert results == 1_045_660
  end
end
