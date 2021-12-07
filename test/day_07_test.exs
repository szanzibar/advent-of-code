defmodule AoC.Day07.Test do
  use ExUnit.Case
  require Logger
  import AoC.Day07

  @tag :d7p1
  test "example: part1" do
    assert part1("test_input") == 37
  end

  @tag :d7p1
  test "real data: part1" do
    results = part1("input")
    Logger.info("part 1 results: #{results}")
    assert results == 344_605
  end
end
