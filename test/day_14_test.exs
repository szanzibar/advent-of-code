defmodule AoC.Day14.Test do
  use ExUnit.Case
  require Logger
  import AoC.Day14

  @tag :d14p1
  test "example: part1" do
    assert part1("test_input") == 1588
  end

  @tag :d14p1real
  test "real data: part1" do
    results = part1("input")
    Logger.info("part 1 results: #{results}")
    assert is_number(results)
  end

  @tag :d14p2
  test "example: part2" do
    assert part2("test_input") == 2_188_189_693_529
  end

  @tag :d14p2real
  test "real data: part2" do
    results = part2("input")
    Logger.info("part 2 results: \n#{results}")

    assert is_number(results)
  end
end
