defmodule AoC.Day17.Test do
  use ExUnit.Case
  import AoC.Day17
  require Logger

  @tag :d17p1
  test "example: part1" do
    assert part1("test_input") == 45
  end

  @tag :d17p1real
  test "real data: part1" do
    results = part1("input")
    Logger.info("part 1 results: #{results}")
    assert results == 4656
  end

  @tag :d17p2
  test "example: part2" do
    assert part2("test_input") == 112
  end

  @tag :d17p2real
  test "real data: part2" do
    results = part2("input")
    Logger.info("part 2 results: \n#{results}")

    assert results == 1908
  end
end
