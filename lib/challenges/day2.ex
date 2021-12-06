defmodule Aoc2021.Day2 do

  def part1() do
    {depth, position} = input()
    |> run({0,0}, &apply_command/2)

    depth * position
  end

  def part2() do
    {depth, position, _aim} = input()
    |> run({0,0,0}, &apply_command_v2/2)

    depth * position
  end

  defp run([], coordinates, _command_function), do: coordinates
  defp run([command|rest], coordinates, command_function) do
    run(rest, command_function.(command, coordinates), command_function)
  end

  defp apply_command({"forward", units}, {depth, position}), do: {depth, position + units}
  defp apply_command({"down", units}, {depth, position}), do: {depth + units, position}
  defp apply_command({"up", units}, {depth, position}), do: {depth - units, position}

  defp apply_command_v2({"forward", units}, {depth, position, aim}), do: {depth + (aim * units), position + units, aim}
  defp apply_command_v2({"down", units}, {depth, position, aim}), do: {depth, position, aim + units}
  defp apply_command_v2({"up", units}, {depth, position, aim}), do: {depth, position, aim - units}

  def input() do
    "day2.txt"
    |> Aoc2021.Input.read_as_list()
    |> Enum.map(fn l -> String.split(l, " ") |> List.to_tuple() end)
    |> Enum.map(fn {command, unit} -> {command, String.to_integer(unit)} end)
  end
end
