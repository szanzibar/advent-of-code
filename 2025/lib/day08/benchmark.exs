alias AoC2025.Day08
alias AoC2025.Day08.Input

Benchee.run(%{
  "part1" => fn -> Day08.part1(Input.input()) end,
  "part2" => fn -> Day08.part2(Input.input()) end
})
