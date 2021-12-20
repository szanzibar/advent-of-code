defmodule AoC.Day16.Test do
  use ExUnit.Case
  require Logger
  import AoC.Day16

  @tag :d16p1
  test "example: part1" do
    assert part1("test_input") == [16, 12, 23, 31]
  end

  @tag :d16p1real
  test "real data: part1" do
    results = part1("input")
    Logger.info("part 1 results: #{results}")
    assert results == 938
  end

  @tag :d16p2
  test "example: part2" do
    assert part2("test_input") == 315
  end

  @tag :d16p2real
  test "real data: part2" do
    results = part2("input")
    Logger.info("part 2 results: \n#{results}")

    assert results == 2825
  end
end
