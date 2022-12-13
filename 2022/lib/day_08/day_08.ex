defmodule AoC2022.Day08 do
  def get_input(file) do
    File.read!(Path.join(__DIR__, file))
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.map(fn {value, index_x} ->
      String.graphemes(value)
      |> Enum.with_index()
      |> Enum.map(fn {grapheme, index_y} ->
        {{index_x, index_y}, grapheme |> String.to_integer()}
      end)
    end)
    |> List.flatten()
    |> Enum.sort_by(fn {key, _} -> key end)
  end

  @doc """
      iex> part1("test_input")
      21

      iex> part1("input")
      # not 9739 too high
      # not 10298 too high
      # not 1086 too low
      # leaving in the attempt progression of shame lol
      1805

  """
  def part1(input_file) do
    trees = get_input(input_file)

    perimeter =
      trees
      |> Enum.map(fn {key, _} -> key end)
      |> Enum.max()
      |> then(fn {x, y} -> 2 * x + 2 * y end)

    left_to_right =
      trees
      |> Enum.chunk_by(fn {{x, _}, _} ->
        x
      end)

    right_to_left =
      trees
      |> Enum.reverse()
      |> Enum.chunk_by(fn {{x, _}, _} ->
        x
      end)

    top_to_bottom =
      trees
      |> Enum.sort_by(fn {{x, y}, _} -> {y, x} end)
      |> Enum.chunk_by(fn {{_, y}, _} ->
        y
      end)

    bottom_to_top =
      trees
      |> Enum.sort_by(fn {{x, y}, _} -> {y, x} end)
      |> Enum.reverse()
      |> Enum.chunk_by(fn {{_, y}, _} ->
        y
      end)

    inner_visible_trees =
      [
        left_to_right,
        right_to_left,
        top_to_bottom,
        bottom_to_top
      ]
      |> Enum.map(&count_tree_rows/1)
      |> Enum.concat()
      |> List.flatten()
      |> Enum.uniq()
      |> Enum.filter(&(&1 != []))
      |> Enum.count()

    inner_visible_trees + perimeter
  end

  def count_tree_rows(rows), do: rows |> drop_ends |> Enum.map(&count_trees/1)
  def drop_ends(enum), do: enum |> Enum.drop(-1) |> Enum.drop(1)

  def count_trees([{_, height} | _] = trees), do: count_trees(trees, height, [])

  def count_trees([_tree, _last_tree | []], _, visible_trees), do: visible_trees

  def count_trees(
        [_, {_, next_tree_height} = next_tree | trees],
        current_highest,
        visible_trees
      )
      when next_tree_height > current_highest do
    count_trees([next_tree | trees], next_tree_height, [next_tree | visible_trees])
  end

  def count_trees([_ | trees], current_highest, visible_trees),
    do: count_trees(trees, current_highest, visible_trees)

  @doc """
    This is slow as fuck lol, but it works

    iex> part2("test_input")
    8

    iex> part2("input")
    # not 16
    444528

  """
  def part2(input_file) do
    trees = get_input(input_file)

    trees
    |> Enum.map(fn {{origin_row, origin_col}, origin_height} ->
      left =
        trees
        |> Enum.filter(fn {{row, col}, _} -> row == origin_row && col < origin_col end)
        |> Enum.sort_by(fn {key, _} -> key end)
        |> Enum.reverse()

      right =
        trees
        |> Enum.filter(fn {{row, col}, _} -> row == origin_row && col > origin_col end)
        |> Enum.sort_by(fn {key, _} -> key end)

      down =
        trees
        |> Enum.sort_by(fn {{x, y}, _} -> {y, x} end)
        |> Enum.filter(fn {{row, col}, _} -> col == origin_col && row > origin_row end)

      up =
        trees
        |> Enum.sort_by(fn {{x, y}, _} -> {y, x} end)
        |> Enum.reverse()
        |> Enum.filter(fn {{row, col}, _} -> col == origin_col && row < origin_row end)

      [
        left,
        right,
        up,
        down
      ]
      |> Enum.map(&count_trees_2(&1, origin_height, []))
      |> Enum.map(&Enum.count/1)
      |> Enum.product()
    end)
    |> Enum.max()
  end

  def count_trees_2([], _, visible_trees), do: visible_trees

  def count_trees_2(
        [{_, tree_height} = tree | trees],
        max_height,
        visible_trees
      )
      when tree_height < max_height do
    count_trees_2(trees, max_height, [tree | visible_trees])
  end

  def count_trees_2([tree | _], _, visible_trees),
    do: [tree | visible_trees]
end
