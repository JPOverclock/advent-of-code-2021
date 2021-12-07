defmodule Aoc2021.Day7 do
  @input "day7.txt"

  def part1(name \\ @input) do
    cost_function = fn crab, position -> abs(position - crab) end
    calculate(name, cost_function)
  end

  def part2(name \\ @input) do
    cost_function = fn crab, position -> 0..abs(position - crab) |> Enum.sum() end
    calculate(name, cost_function)
  end

  defp calculate(name, cost_function) do
    input = input(name)

    {min, max} = {Enum.min(input), Enum.max(input)}

    min..max
    |> Enum.map(fn position -> {position, calculate_fuel(input, position, 0, cost_function)} end)
    |> Enum.min(fn {_, cost1}, {_, cost2} -> cost1 <= cost2 end)
  end

  defp calculate_fuel([], _position, cost, _cost_function), do: cost

  defp calculate_fuel([crab | rest], position, cost, cost_function) do
    calculate_fuel(rest, position, cost + cost_function.(crab, position), cost_function)
  end

  defp input(filename) do
    filename
    |> Aoc2021.Input.read_raw()
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
