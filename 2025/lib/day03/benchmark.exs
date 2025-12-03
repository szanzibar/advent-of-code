alias AoC2025.Day03
alias AoC2025.Day03.Input

Benchee.run(%{
  "part1" => fn -> Day03.part1(Input.input()) end,
  "part2" => fn -> Day03.part2(Input.input()) end
})
