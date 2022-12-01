defmodule AoC.Day07.Test do
  use ExUnit.Case
  require Logger
  import AoC.Day07

  @tag :d7p1
  test "example: part1" do
    assert part1("test_input") == 37
  end

  @tag :d7p1
  test "real data: part1" do
    results = part1("input")
    Logger.info("part 1 results: #{results}")
    assert results == 344_605
  end

  @tag :d7p2
  test "example: part2" do
    assert part2("test_input") == 168
  end

  @tag :d7p2
  test "real data: part2" do
    results = part2("input")
    Logger.info("part 2 results: #{results}")
    assert results == 93_699_985
  end
end
