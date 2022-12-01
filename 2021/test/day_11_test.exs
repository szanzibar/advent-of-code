defmodule AoC.Day11.Test do
  use ExUnit.Case
  require Logger
  import AoC.Day11

  @tag :d11p1
  test "example: part1" do
    assert part1("test_input") == 1656
  end

  @tag :d11p1real
  test "real data: part1" do
    results = part1("input")
    Logger.info("part 1 results: #{results}")
    assert results == 1785
  end

  @tag :d11p2
  test "example: part2" do
    assert part2("test_input") == 195
  end

  @tag :d11p2real
  test "real data: part2" do
    results = part2("input")
    Logger.info("part 2 results: #{results}")
    assert results == 354
  end
end
