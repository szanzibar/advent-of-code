alias AoC2024.Day13
alias AoC2024.Day13.Input

Benchee.run(%{
  "part1" => fn -> Day13.part1(Input.input()) end,
  "part2" => fn -> Day13.part2(Input.input()) end
})
