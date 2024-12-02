alias AoC2024.Day02
alias AoC2024.Day02.Input

Benchee.run(%{
  "part1" => fn -> Day02.part1(Input.input()) end,
  "part2" => fn -> Day02.part2(Input.input()) end
})
