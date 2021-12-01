defmodule AoC.SonarSweepTest do
  use ExUnit.Case

  test "example: counts depth measurement increases" do
    measurements = [199, 200, 208, 210, 200, 207, 240, 269, 260, 263]
    assert AoC.SonarSweep.sonar_sweep(measurements) == 7
  end

  test "real data from file: counts depth measurement increases" do
    measurements = "input"
    assert is_integer(AoC.SonarSweep.sonar_sweep(measurements))
  end
end
