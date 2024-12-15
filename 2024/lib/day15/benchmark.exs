alias AoC2024.Day15
alias AoC2024.Day15.Input

Benchee.run(%{
  "part1" => fn -> Day15.part1(Input.input()) end,
  "part2" => fn -> Day15.part2(Input.input()) end
})
