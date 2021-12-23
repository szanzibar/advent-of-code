defmodule AoC.Day18.Test do
  use ExUnit.Case
  import AoC.Day18
  require Logger

  @tag :d18p1
  test "example: part1" do
    assert part1("test_input") == 4140
  end

  @tag :d18p1real
  test "real data: part1" do
    results = part1("input")
    Logger.info("part 1 results: #{results}")
    assert results == 3524
  end

  @tag :d18p2
  test "example: part2" do
    assert part2("test_input") == 3993
  end

  @tag :d18p2real
  test "real data: part2" do
    results = part2("input")
    Logger.info("part 2 results: \n#{results}")

    assert results == 4656
  end
end
