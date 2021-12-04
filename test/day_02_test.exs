defmodule AoC.Day02.Test do
  use ExUnit.Case
  require Logger
  @test_measurements "test_input"
  @real_measurements "input"

  test "example: part1" do
    assert AoC.Day02.part1(@test_measurements) == 150
  end

  test "real data: part1" do
    results = AoC.Day02.part1(@real_measurements)
    Logger.info("part 1 results: #{results}")
    assert is_integer(results)
  end

  test "example: part2" do
    assert AoC.Day02.part2(@test_measurements) == 900
  end

    test "real data: part2" do
    results = AoC.Day02.part2(@real_measurements)
    Logger.info("part 2 results: #{results}")
    assert is_integer(results)
  end
end
