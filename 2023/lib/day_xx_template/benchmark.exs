alias AoC2023.Dayxx
alias AoC2023.Dayxx.Input

Benchee.run(%{
  "part1" => fn -> Dayxx.part1(Input.input()) end,
  "part2" => fn -> Dayxx.part2(Input.input()) end
})
