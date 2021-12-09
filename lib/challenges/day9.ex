defmodule Aoc2021.Day9 do
  @input "day9.txt"

  def part1(input \\ @input) do
    input(input)
    |> make_map()
    |> minima()
    |> Enum.map(fn {_, element} -> element + 1 end)
    |> Enum.sum()
  end

  def part2(input \\ @input) do
    map = input(input)
    |> make_map()

    map
    |> minima()
    |> Enum.map(fn minimum -> calculate_basin(map, [minimum], [minimum]) end)
    |> Enum.map(&Enum.count/1)
    |> Enum.sort()
    |> Enum.reverse()
    |> Enum.take(3)
    |> Enum.reduce(&*/2)
  end

  defp calculate_basin(_, points, []), do: points
  defp calculate_basin(map, points, frontier) do
    new_frontier = frontier
    |> Enum.map(fn point -> {point, neighbours(map, point)} end)
    |> Enum.flat_map(fn {{_, value}, neighbours} ->
      neighbours
      |> Enum.filter(fn {_, v} -> v < 9 and v > value end)
    end)
    |> Enum.reject(fn point -> Enum.member?(points, point) end)
    |> Enum.uniq()

    calculate_basin(map, points ++ new_frontier, new_frontier)
  end

  defp minima(map) do
    map
    |> all_points()
    |> Enum.filter(fn point -> is_minimum?(map, point) end)
  end

  defp make_map(raw_input) do
    y_max = tuple_size(raw_input) - 1
    x_max = tuple_size(elem(raw_input, 0)) - 1

    {y_max, x_max, raw_input}
  end

  defp point_at({_,_, matrix}, y, x), do: {{y, x}, matrix |> elem(y) |> elem(x)}

  defp all_points({y_max, x_max, _} = map) do
    for y <- 0..y_max, x <- 0..x_max do
      point_at(map, y, x)
    end
  end

  defp neighbours({y_max, x_max, _} = map, {{y,x}, _}) do
    neighbouring_coordinates(y,x,y_max,x_max)
    |> Enum.map(fn {i,j} -> point_at(map, i, j) end)
  end

  defp is_minimum?(map, {_, value} = point) do
    map
    |> neighbours(point)
    |> Enum.all?(fn {_, v} -> v > value end)
  end

  defp neighbouring_coordinates(0,0, _, _), do: [{0,1}, {1,0}]
  defp neighbouring_coordinates(y, x, y, x), do: [{y - 1, x}, {y, x - 1}]

  defp neighbouring_coordinates(0,x,_,x), do: [{1, x}, {0, x - 1}]
  defp neighbouring_coordinates(0,x,_,_), do: [{0, x - 1}, {0, x + 1}, {1, x}]

  defp neighbouring_coordinates(y,0,y,_), do: [{y, 1}, {y - 1, 0}]
  defp neighbouring_coordinates(y,0,_,_), do: [{y, 1}, {y - 1, 0}, {y + 1, 0}]

  defp neighbouring_coordinates(y,x,y,_), do: [{y, x - 1}, {y, x + 1}, {y - 1, x}]
  defp neighbouring_coordinates(y,x,_,x), do: [{y, x - 1}, {y - 1, x}, {y + 1, x}]

  defp neighbouring_coordinates(y,x,_,_), do: [{y, x - 1}, {y, x + 1}, {y - 1, x}, {y + 1, x}]

  defp input(filename) do
    filename
    |> Aoc2021.Input.read_as_stream()
    |> Stream.map(&String.trim/1)
    |> Enum.map(fn line ->
      line
      |> String.split("", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
    |> List.to_tuple()
  end
end
