alias AoC2024.Day04
alias AoC2024.Day04.Input

Benchee.run(%{
  "part1" => fn -> Day04.part1(Input.input()) end,
  "part2" => fn -> Day04.part2(Input.input()) end
})
