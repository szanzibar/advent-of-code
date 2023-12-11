alias AoC2023.Day11
alias AoC2023.Day11.Input

Benchee.run(%{
  "part1" => fn -> Day11.part1(Input.input()) end,
  "part2" => fn -> Day11.part2(Input.input()) end
})
