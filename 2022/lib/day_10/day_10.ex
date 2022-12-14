defmodule AoC2022.Day10 do
  def get_input(file) do
    File.read!(Path.join(__DIR__, file))
    |> String.split("\n")
    |> Enum.map(fn instruction ->
      [command | value] = String.split(instruction, " ", trim: true)

      if Enum.empty?(value) do
        {command}
      else
        {command, String.to_integer(Enum.at(value, 0))}
      end
    end)
  end

  @core_cycles [20, 60, 100, 140, 180, 220]

  @doc """
      iex> part1("test_input")
      13140

      iex> part1("input")
      12980

  """
  def part1(input_file) do
    get_input(input_file) |> process_instructions(1, 1, 0)
  end

  def process_instructions([], _cycle, _x, pixels), do: pixels

  def process_instructions([{"noop"} | instructions], cycle, x, pixels) do
    pixels = check_pixels(cycle, x, pixels)

    process_instructions(instructions, cycle + 1, x, pixels)
  end

  def process_instructions([{"addx", value} | instructions], cycle, x, pixels) do
    test_cycle =
      if Enum.any?(@core_cycles, &(cycle + 1 == &1)) do
        cycle + 1
      else
        cycle
      end

    pixels = check_pixels(test_cycle, x, pixels)

    process_instructions(instructions, cycle + 2, x + value, pixels)
  end

  def check_pixels(cycle, x, pixels)
      when cycle in @core_cycles do
    x * cycle + pixels
  end

  def check_pixels(_, _, pixels), do: pixels

  @doc """
    iex> part2("test_input")
    "
    ##..##..##..##..##..##..##..##..##..##..
    ###...###...###...###...###...###...###.
    ####....####....####....####....####....
    #####.....#####.....#####.....#####.....
    ######......######......######......####
    #######.......#######.......#######....."

    iex> part2("input")
    "
    ###..###....##.#....####.#..#.#....###..
    #..#.#..#....#.#....#....#..#.#....#..#.
    ###..#..#....#.#....###..#..#.#....#..#.
    #..#.###.....#.#....#....#..#.#....###..
    #..#.#.#..#..#.#....#....#..#.#....#....
    ###..#..#..##..####.#.....##..####.#...."

  """
  def part2(input_file) do
    get_input(input_file)
    |> process_instructions_2(1, 1, [])
    |> Enum.map_every(40, fn x -> "\n" <> x end)
    |> Enum.join()
    |> tap(&IO.puts/1)
  end

  def process_instructions_2([], _cycle, _x, pixels), do: pixels |> Enum.reverse()

  def process_instructions_2([{"noop"} | instructions], cycle, x, pixels) do
    pixels = draw_pixel(cycle, x, pixels)
    process_instructions_2(instructions, cycle + 1, x, pixels)
  end

  def process_instructions_2([{"addx", value} | instructions], cycle, x, pixels) do
    pixels = draw_pixel(cycle, x, pixels)
    addx_cycle_2(instructions, cycle + 1, x, value, pixels)
  end

  def addx_cycle_2(instructions, cycle, x, value, pixels) do
    pixels = draw_pixel(cycle, x, pixels)
    process_instructions_2(instructions, cycle + 1, x + value, pixels)
  end

  def draw_pixel(cycle, x, pixels) when cycle > 40, do: draw_pixel(cycle - 40, x, pixels)

  def draw_pixel(cycle, x, pixels) do
    drawing = cycle - 1

    new_pixel =
      if x == drawing || x + 1 == drawing || x - 1 == drawing do
        "#"
      else
        "."
      end

    [new_pixel | pixels]
  end
end
