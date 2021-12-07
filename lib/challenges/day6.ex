defmodule Aoc2021.Day6 do
  @input "day6.txt"

  def part1(name \\ @input) do
    fish =
      name
      |> input()

    {pond, count} = simulate(80, fish, %{}, 0)
    Enum.count(pond) + count
  end

  def part2(name \\ @input) do
    fish =
      name
      |> input()

    # Memoize up to depth = 128, as this makes the solution converge faster
    memo =
      1..128
      |> Enum.map(fn depth -> memoize(depth) end)
      |> Enum.reduce(fn x, accum -> Map.merge(x, accum) end)

    {pond, count} = simulate(256, fish, memo, 0)
    Enum.count(pond) + count
  end

  defp memoize(depth) do
    0..6
    |> Enum.map(fn fish -> {depth, fish, simulate(depth, [fish], %{}, 0)} end)
    |> Enum.map(fn {n, fish, {pond, count}} -> {{n, fish}, count + Enum.count(pond)} end)
    |> Map.new()
  end

  defp simulate(0, fish, _memoization, counts), do: {fish, counts}

  defp simulate(n, fish, memoization, counts) do
    {accum, count} = simulate_lanternfish(fish, n, [], memoization, 0)
    simulate(n - 1, accum, memoization, counts + count)
  end

  defp simulate_lanternfish([], _n, accum, _memoization, count), do: {accum, count}

  defp simulate_lanternfish([0 | rest], n, accum, memoization, count) do
    simulate_lanternfish(rest, n, [8 | [6 | accum]], memoization, count)
  end

  defp simulate_lanternfish([fish | rest], n, accum, memoization, count) do
    key = {n, fish}

    case memoization do
      %{^key => result} -> simulate_lanternfish(rest, n, accum, memoization, count + result)
      _ -> simulate_lanternfish(rest, n, [fish - 1 | accum], memoization, count)
    end
  end

  defp input(name) do
    name
    |> Aoc2021.Input.read_raw()
    |> String.trim()
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
