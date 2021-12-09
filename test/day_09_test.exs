defmodule AoC.Day09.Test do
  use ExUnit.Case
  require Logger
  import AoC.Day09

  @tag :d9p1
  test "example: part1" do
    assert part1("test_input") == 15
  end

  @tag :d9p1real
  test "real data: part1" do
    results = part1("input")
    Logger.info("part 1 results: #{results}")
    assert results == 480
  end

  @tag :d9p2
  test "example: part2" do
    assert part2("test_input") == 1134
  end

  @tag :d9p2real
  test "real data: part2" do
    results = part2("input")
    Logger.info("part 2 results: #{results}")
    assert results == 1_045_660
  end
end
