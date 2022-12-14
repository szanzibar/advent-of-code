defmodule AoC2022.Day11.Input do
  def get_test_input do
    %{
      "monkey_0" => %{
        items: [79, 98],
        operation: fn old -> old * 19 end,
        test: fn val -> if rem(val, 23) == 0, do: "monkey_2", else: "monkey_3" end,
        inspect_count: 0,
        divisor: 23
      },
      "monkey_1" => %{
        items: [54, 65, 75, 74],
        operation: fn old -> old + 6 end,
        test: fn val -> if rem(val, 19) == 0, do: "monkey_2", else: "monkey_0" end,
        inspect_count: 0,
        divisor: 19
      },
      "monkey_2" => %{
        items: [79, 60, 97],
        operation: fn old -> old * old end,
        test: fn val -> if rem(val, 13) == 0, do: "monkey_1", else: "monkey_3" end,
        inspect_count: 0,
        divisor: 13
      },
      "monkey_3" => %{
        items: [74],
        operation: fn old -> old + 3 end,
        test: fn val -> if rem(val, 17) == 0, do: "monkey_0", else: "monkey_1" end,
        inspect_count: 0,
        divisor: 17
      }
    }
  end

  def get_input do
    %{
      "monkey_0" => %{
        items: [91, 54, 70, 61, 64, 64, 60, 85],
        operation: fn old -> old * 13 end,
        test: fn val -> if rem(val, 2) == 0, do: "monkey_5", else: "monkey_2" end,
        inspect_count: 0,
        divisor: 2
      },
      "monkey_1" => %{
        items: [82],
        operation: fn old -> old + 7 end,
        test: fn val -> if rem(val, 13) == 0, do: "monkey_4", else: "monkey_3" end,
        inspect_count: 0,
        divisor: 13
      },
      "monkey_2" => %{
        items: [84, 93, 70],
        operation: fn old -> old + 2 end,
        test: fn val -> if rem(val, 5) == 0, do: "monkey_5", else: "monkey_1" end,
        inspect_count: 0,
        divisor: 5
      },
      "monkey_3" => %{
        items: [78, 56, 85, 93],
        operation: fn old -> old * 2 end,
        test: fn val -> if rem(val, 3) == 0, do: "monkey_6", else: "monkey_7" end,
        inspect_count: 0,
        divisor: 3
      },
      "monkey_4" => %{
        items: [64, 57, 81, 95, 52, 71, 58],
        operation: fn old -> old * old end,
        test: fn val -> if rem(val, 11) == 0, do: "monkey_7", else: "monkey_3" end,
        inspect_count: 0,
        divisor: 11
      },
      "monkey_5" => %{
        items: [58, 71, 96, 58, 68, 90],
        operation: fn old -> old + 6 end,
        test: fn val -> if rem(val, 17) == 0, do: "monkey_4", else: "monkey_1" end,
        inspect_count: 0,
        divisor: 17
      },
      "monkey_6" => %{
        items: [56, 99, 89, 97, 81],
        operation: fn old -> old + 1 end,
        test: fn val -> if rem(val, 7) == 0, do: "monkey_0", else: "monkey_2" end,
        inspect_count: 0,
        divisor: 7
      },
      "monkey_7" => %{
        items: [68, 72],
        operation: fn old -> old + 8 end,
        test: fn val -> if rem(val, 19) == 0, do: "monkey_6", else: "monkey_0" end,
        inspect_count: 0,
        divisor: 19
      }
    }
  end
end
