defmodule Aoc2021.Day13 do
  @input "day13.txt"

  def part1(input \\ @input) do
    {points, [axis | _]} = input(input)

    fold(points, axis, [])
    |> Enum.uniq()
    |> Enum.count()
  end

  def part2(input \\ @input) do
    {points, instructions} = input(input)

    instructions
    |> Enum.reduce(points, fn axis, points ->
      fold(points, axis, []) |> Enum.uniq()
    end)
    |> to_graphics()
  end

  @doc """
  Displays graphics as per the output of part2
  """
  def display(graphics) do
    graphics
    |> Enum.map(&Enum.join/1)
    |> Enum.join("\n")
    |> IO.puts()
  end

  def fold([], _axis, result), do: result

  def fold([{_,y} = point | rest], {"y", value} = axis, result) when y < value, do: fold(rest, axis, [point | result])
  def fold([{x,_} = point | rest], {"x", value} = axis, result) when x < value, do: fold(rest, axis, [point | result])

  def fold([{x,y} | rest], {"x", value} = axis, result) do
    fold(rest, axis, [{value - (x - value), y} | result])
  end

  def fold([{x,y} | rest], {"y", value} = axis, result) do
    fold(rest, axis, [{x, value - (y - value)} | result])
  end

  def to_graphics(points) do
    max_x = points |> Enum.map(fn {x,_} -> x end) |> Enum.max()
    max_y = points |> Enum.map(fn {_,y} -> y end) |> Enum.max()

    for y <- 0..max_y do
      for x <- 0..max_x do
        case Enum.member?(points, {x,y}) do
          true -> "#"
          false -> " "
        end
      end
    end
  end

  def input(filename) do
    [points_part, instructions_part] = filename
    |> Aoc2021.Input.read_raw()
    |> String.split("\n\n", trim: true)

    points = points_part
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> String.split(line, ",", trim: true) end)
    |> Enum.map(fn [x,y] -> {String.to_integer(x), String.to_integer(y)} end)

    instructions = instructions_part
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> String.replace(line, "fold along ", "") end)
    |> Enum.map(fn line -> String.split(line, "=", trim: true) end)
    |> Enum.map(fn [axis, value] -> {axis, String.to_integer(value)} end)

    {points, instructions}
  end
end
