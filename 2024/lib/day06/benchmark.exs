alias AoC2024.Day06
alias AoC2024.Day06.Input

Benchee.run(%{
  "part1" => fn -> Day06.part1(Input.input()) end,
  "part2" => fn -> Day06.part2(Input.input()) end
})
