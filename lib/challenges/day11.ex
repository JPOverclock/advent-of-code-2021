defmodule Aoc2021.Day11 do
  @input "day11.txt"

  def part1(input \\ @input, iterations \\ 100) do
    map = input(input)
    initial_burst = for i <- 0..9, j <- 0..9, do: {i,j}

    1..iterations
    |> Enum.reduce({map, 0}, fn _, {m,f} -> simulate(m, f, initial_burst, []) end)
  end

  def part2(input \\ @input) do
    map = input(input)
    initial_burst = for i <- 0..9, j <- 0..9, do: {i,j}

    Stream.iterate(1, &(&1+1))
    |> Enum.reduce_while({1, map, 0}, fn i, {_,m,f} ->
      {new_map, new_flashes} = simulate(m, f, initial_burst, [])

      case all_flashing?(new_map) do
        false -> {:cont, {i, new_map, new_flashes}}
        _ -> {:halt, {i, new_map, new_flashes}}
      end
    end)
  end

  defp simulate(map, flashes, [], _flashed), do: {map, flashes}
  defp simulate(map, flashes, bursts, flashed) do
    {next_map, next_flashes, next_bursts, next_flashed} = bursts
    |> Enum.reduce({map, flashes, [], flashed}, fn {i,j}, {m, f, b, ff} ->
      octopus = (m |> elem(i) |> elem(j))

      {octopus_value, next_flashes, next_bursts, next_flashed} = cond do
        octopus + 1 > 9 -> {0, f + 1, b ++ neighbouring_coordinates({i,j}), [{i,j} | ff]}
        octopus == 0 and Enum.member?(ff, {i,j}) -> {octopus, f, b, ff}
        true -> {octopus + 1, f, b, ff}
      end

      updated_row = put_elem(m |> elem(i), j, octopus_value)
      next_map = put_elem(m, i, updated_row)

      {next_map, next_flashes, next_bursts, next_flashed}
    end)

    simulate(next_map, next_flashes, next_bursts, next_flashed)
  end

  defp neighbouring_coordinates({0,0}), do: [{0,1}, {1,0},{1,1}]
  defp neighbouring_coordinates({9,9}), do: [{8,9},{9,8},{8,8}]
  defp neighbouring_coordinates({0,9}), do: [{0,8},{1,8},{1,9}]
  defp neighbouring_coordinates({9,0}), do: [{8,0},{8,1},{9,1}]

  defp neighbouring_coordinates({9,j}), do: [{8, j - 1}, {8, j}, {8, j + 1}, {9, j - 1}, {9, j + 1}]
  defp neighbouring_coordinates({0,j}), do: [{1, j - 1}, {1, j}, {1, j + 1}, {0, j - 1}, {0, j + 1}]

  defp neighbouring_coordinates({i,9}), do: [{i - 1, 9}, {i - 1, 8}, {i + 1, 9}, {i + 1, 8}, {i, 8}]
  defp neighbouring_coordinates({i,0}), do: [{i - 1, 0}, {i - 1, 1}, {i + 1, 0}, {i + 1, 1}, {i, 1}]

  defp neighbouring_coordinates({i,j}) do
    [
      {i - 1, j - 1}, {i - 1, j}, {i - 1, j + 1},
      {i, j - 1}, {i, j + 1},
      {i + 1, j - 1}, {i + 1, j}, {i + 1, j + 1}
    ]
  end

  defp all_flashing?(map) do
    coordinates = for i <- 0..9, j <- 0..9, do: {i,j}

    coordinates
    |> Enum.map(fn {i,j} -> map |> elem(i) |> elem(j) end)
    |> Enum.sum() == 0
  end

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
