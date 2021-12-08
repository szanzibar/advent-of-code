defmodule AoC.Day08.Test do
  use ExUnit.Case
  require Logger
  import AoC.Day08

  @tag :d8p1
  test "example: part1" do
    assert part1("test_input") == 26
  end

  @tag :d8p1
  test "real data: part1" do
    results = part1("input")
    Logger.info("part 1 results: #{results}")
    assert results == 449
  end

  @tag :d8p2
  test "example: part2" do
    assert part2("test_input") == 61_229
  end

  @tag :d8p2
  test "real data: part2" do
    results = part2("input")
    Logger.info("part 2 results: #{results}")
    assert results == 968_175
  end
end
