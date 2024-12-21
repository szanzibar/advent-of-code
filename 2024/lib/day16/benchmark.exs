alias AoC2024.Day16
alias AoC2024.Day16.Input

Benchee.run(%{
  "part1" => fn -> Day16.part1(Input.input()) end,
  "part2" => fn -> Day16.part2(Input.input()) end
})
