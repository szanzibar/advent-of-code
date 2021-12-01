defmodule AoC.SonarSweepTest do
  use ExUnit.Case
  @measurements [199, 200, 208, 210, 200, 207, 240, 269, 260, 263]
  @measurements_file "input"

  test "example: counts depth measurement increases" do
    assert AoC.SonarSweep.increases(@measurements) == 7
  end

  test "real data from file: counts depth measurement increases" do
    assert is_integer(AoC.SonarSweep.increases(@measurements_file))
  end

  test "example: sonar sweep sums" do
    assert AoC.SonarSweep.window_increases(@measurements) == 5
  end

  test "real data from file: counts depth measurement window increases" do
    assert is_integer(AoC.SonarSweep.window_increases(@measurements_file))
  end
end
