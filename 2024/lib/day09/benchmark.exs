alias AoC2024.Day09
alias AoC2024.Day09.Input

Benchee.run(%{
  "part1" => fn -> Day09.part1(Input.input()) end,
  "part2" => fn -> Day09.part2(Input.input()) end
})
