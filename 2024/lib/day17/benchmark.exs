alias AoC2024.Day17
alias AoC2024.Day17.Input

Benchee.run(%{
  "part1" => fn -> Day17.part1(Input.input()) end,
  "part2" => fn -> Day17.part2(Input.input()) end
})
