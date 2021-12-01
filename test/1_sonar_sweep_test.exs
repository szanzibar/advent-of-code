defmodule AoC.SonarSweepTest do
  use ExUnit.Case
  require Logger
  @test_measurements "test_input"
  @real_measurements "input"

  test "example: counts depth measurement part1" do
    assert AoC.SonarSweep.part1(@test_measurements) == 7
  end

  test "real data from file: counts depth measurement part1" do
    results = AoC.SonarSweep.part1(@real_measurements)
    Logger.info("part 1 results: #{results}")
    assert is_integer(results)
  end

  test "example: sonar sweep sums" do
    assert AoC.SonarSweep.part2(@test_measurements) == 5
  end

  test "real data from file: counts depth measurement window part1" do
    results = AoC.SonarSweep.part2(@real_measurements)
    Logger.info("part 2 results: #{results}")
    assert is_integer(results)
  end
end
