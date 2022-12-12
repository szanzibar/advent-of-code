defmodule AoC2022.Day07 do
  def get_input(file) do
    File.read!(Path.join(__DIR__, file)) |> String.split("\n")
  end

  @doc """
      iex> part1("test_input")
      95437

      iex> part1("input")
      1206825

  """
  def part1(input_file) do
    get_input(input_file)
    |> process_lines
    |> Enum.filter(fn {_key, val} -> val <= 100_000 end)
    |> Enum.reduce(0, fn {_key, val}, acc -> val + acc end)
  end

  # commands
  def process_lines(["$ cd /" | lines]), do: process_lines(lines, ["/"], %{"/" => %{}}, %{})

  def process_lines(["$ ls" | lines], path, fs, sizes) do
    process_lines(lines, path, fs, sizes)
  end

  def process_lines(["$ cd .." | lines], [_ | new_path], fs, sizes),
    do: process_lines(lines, new_path, fs, sizes)

  def process_lines(["$ cd " <> letter | lines], path, fs, sizes),
    do: process_lines(lines, [letter | path], fs, sizes)

  # folders
  def process_lines(["dir " <> letter | lines], path, fs, sizes) do
    process_lines(lines, path, put_in(fs, Enum.reverse([letter | path]), %{}), sizes)
  end

  # file
  def process_lines([file | lines], path, fs, sizes) do
    [size, name] = String.split(file, " ")
    size = size |> String.to_integer()

    new_sizes = add_sizes(sizes, size, path)

    process_lines(
      lines,
      path,
      put_in(fs, Enum.reverse([name | path]), size),
      new_sizes
    )
  end

  def process_lines([], _path, _fs, sizes), do: sizes

  def add_sizes(sizes, _, []), do: sizes

  def add_sizes(sizes, new_size, [path | paths]) do
    {_, new_sizes} =
      Map.get_and_update(sizes, [path | paths], fn existing_size ->
        {existing_size, (existing_size || 0) + new_size}
      end)

    add_sizes(new_sizes, new_size, paths)
  end

  @doc """
      iex> part2("test_input")
      24933642

      iex> part2("input")
      9608311

  """
  def part2(input_file) do
    disk_size = 70_000_000
    unused_goal = 30_000_000
    sizes = get_input(input_file) |> process_lines |> Enum.map(fn {_key, val} -> val end)

    total_used = sizes |> Enum.max()
    to_delete = unused_goal - (disk_size - total_used)
    sizes |> Enum.filter(&(&1 >= to_delete)) |> Enum.min()
  end
end
