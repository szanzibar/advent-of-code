alias AoC2024.Day10
alias AoC2024.Day10.Input

Benchee.run(%{
  "part1" => fn -> Day10.part1(Input.input()) end,
  "part2" => fn -> Day10.part2(Input.input()) end
})
