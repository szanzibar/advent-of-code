alias AoC2024.Dayxx
alias AoC2024.Dayxx.Input

Benchee.run(%{
  "part1" => fn -> Dayxx.part1(Input.input()) end,
  "part2" => fn -> Dayxx.part2(Input.input()) end
})
