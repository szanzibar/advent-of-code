alias AoC2024.Day05
alias AoC2024.Day05.Input

Benchee.run(%{
  "part1" => fn -> Day05.part1(Input.input()) end,
  "part2" => fn -> Day05.part2(Input.input()) end
})
