defmodule AoC.Day12.Test do
  use ExUnit.Case
  require Logger
  import AoC.Day12

  @tag :d12p1t1
  test "example: part1 test 1" do
    assert part1("test_input_1") == 10
  end

  @tag :d12p1t2
  test "example: part1 test 2" do
    assert part1("test_input_2") == 19
  end

  @tag :d12p1t3
  test "example: part1 test 3" do
    assert part1("test_input_3") == 226
  end

  @tag :d12p1real
  test "real data: part1" do
    results = part1("input")
    Logger.info("part 1 results: #{results}")
    assert results == 5254
  end

  @tag :d12p2t1
  test "example: part2 test 1" do
    assert part2("test_input_1") == 36
  end

  @tag :d12p2t2
  test "example: part2 test 2" do
    assert part2("test_input_2") == 103
  end

  @tag :d12p2t3
  test "example: part2 test 3" do
    assert part2("test_input_3") == 3509
  end

  @tag :d12p2real
  test "real data: part2" do
    results = part2("input")
    Logger.info("part 2 results: #{results}")
    assert results == 149_385
  end
end
