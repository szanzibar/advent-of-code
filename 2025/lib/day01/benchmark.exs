alias AoC2025.Day01
alias AoC2025.Day01.Input

Benchee.run(%{
  "part1" => fn -> Day01.part1(Input.input()) end,
  "part2" => fn -> Day01.part2(Input.input()) end
})
