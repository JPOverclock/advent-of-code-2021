defmodule Aoc2021.Day6 do
  @input "day6.txt"

  def part1(name \\ @input) do
    fish = name
    |> input()

    1..80
    |> Enum.reduce(fish, fn _,fish -> simulate_lanternfish(fish, []) end)
    |> Enum.count()
  end

  def part2(name \\ @input) do
    fish = name
    |> input()

    1..256
    |> Enum.reduce(fish, fn _,fish -> simulate_lanternfish(fish, []) end)
    |> Enum.count()
  end

  def simulate(0, fish), do: fish
  def simulate(n, fish), do: simulate(n - 1, simulate_lanternfish(fish, []))

  def simulate_lanternfish([], accum), do: accum

  def simulate_lanternfish([0|rest], accum) do
    simulate_lanternfish(rest, [8 | [6 | accum]])
  end

  def simulate_lanternfish([fish|rest], accum) do
    simulate_lanternfish(rest, [fish - 1 | accum])
  end

  def input(name \\ @input) do
    name
    |> Aoc2021.Input.read_raw()
    |> String.trim()
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
