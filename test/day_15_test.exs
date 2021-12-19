defmodule AoC.Day15.Test do
  use ExUnit.Case
  require Logger
  import AoC.Day15

  @tag :d15p1
  test "example: part1" do
    assert part1("test_input") == 40
  end

  @tag :d15p1real
  test "real data: part1" do
    results = part1("input")
    Logger.info("part 1 results: #{results}")
    assert results == 447
  end

  @tag :d15p2
  test "example: part2" do
    assert part2("test_input") == 315
  end

  @tag :d15p2real
  test "real data: part2" do
    results = part2("input")
    Logger.info("part 2 results: \n#{results}")

    assert results == 2825
  end
end
