defmodule AoC.Day13.Test do
  use ExUnit.Case
  require Logger
  import AoC.Day13

  @tag :d13p1
  test "example: part1" do
    assert part1("test_input") == 17
  end

  @tag :d13p1real
  test "real data: part1" do
    results = part1("input")
    Logger.info("part 1 results: #{results}")
    assert results == 704
  end

  @tag :d13p2real
  test "real data: part2" do
    results = part2("input")
    Logger.info("part 2 results: \n#{results}")

    expected = """
    #..#..##...##....##.###..####.#..#..##..
    #..#.#..#.#..#....#.#..#.#....#..#.#..#.
    ####.#....#..#....#.###..###..####.#....
    #..#.#.##.####....#.#..#.#....#..#.#....
    #..#.#..#.#..#.#..#.#..#.#....#..#.#..#.
    #..#..###.#..#..##..###..####.#..#..##..
    """

    assert results == expected
  end
end
