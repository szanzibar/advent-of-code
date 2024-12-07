alias AoC2024.Day07
alias AoC2024.Day07.Input

Benchee.run(%{
  "part1" => fn -> Day07.part1(Input.input()) end,
  "part2" => fn -> Day07.part2(Input.input()) end
})
