defmodule Aoc2021.Day5 do
  @input "day5.txt"

  def part1(input \\ @input) do
    input
    |> input()
    |> Enum.filter(&is_vertical_or_horizontal?/1)
    |> Enum.flat_map(&expand/1)
    |> Enum.reduce(%{}, fn point, acc ->
      Map.put(acc, point, (acc[point] || 0) + 1)
    end)
    |> Enum.filter(fn {_point, count} -> count >= 2 end)
    |> Enum.count()
  end

  def part2(input \\ @input) do
    input
    |> input()
    |> Enum.filter(&is_eligible_line?/1)
    |> Enum.flat_map(&expand/1)
    |> Enum.reduce(%{}, fn point, acc ->
      Map.put(acc, point, (acc[point] || 0) + 1)
    end)
    |> Enum.filter(fn {_point, count} -> count >= 2 end)
    |> Enum.count()
  end

  defp input(filename) do
    filename
    |> Aoc2021.Input.read_raw()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> line_to_coordinates(line) end)
  end

  defp line_to_coordinates(line) do
    [a, b] =
      line
      |> String.split(" -> ", trim: true)

    {to_coordinates(a), to_coordinates(b)}
  end

  defp to_coordinates(str) do
    [x, y] =
      str
      |> String.split(",", trim: true)

    {String.to_integer(x), String.to_integer(y)}
  end

  def expand({start, _end} = line) do
    do_expand(line, [], start, step(line))
  end

  defp do_expand({_, last_point}, points, last_point, _step),
    do: [last_point | points]

  defp do_expand(line, points, {x, y} = cursor, {x_step, y_step} = step) do
    do_expand(line, [cursor | points], {x + x_step, y + y_step}, step)
  end

  defp step({{a, b}, {a, c}}) when c > b, do: {0, 1}
  defp step({{a, _}, {a, _}}), do: {0, -1}

  defp step({{b, a}, {c, a}}) when c > b, do: {1, 0}
  defp step({{_, a}, {_, a}}), do: {-1, 0}

  defp step({{a, b}, {c, d}}) do
    {div(c - a, abs(c - a)), div(d - b, abs(d - b))}
  end

  defp is_vertical?({{a, _}, {a, _}}), do: true
  defp is_vertical?(_), do: false

  defp is_horizontal?({{_, a}, {_, a}}), do: true
  defp is_horizontal?(_), do: false

  defp is_diagonal?({{a, b}, {c, d}}), do: abs(c - a) == abs(d - b)

  defp is_vertical_or_horizontal?(line), do: is_vertical?(line) or is_horizontal?(line)
  defp is_eligible_line?(line), do: is_vertical_or_horizontal?(line) or is_diagonal?(line)
end
