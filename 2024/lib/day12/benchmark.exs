alias AoC2024.Day12
alias AoC2024.Day12.Input

Benchee.run(%{
  "part1" => fn -> Day12.part1(Input.input()) end,
  "part2" => fn -> Day12.part2(Input.input()) end
})
