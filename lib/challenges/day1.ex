defmodule Aoc2021.Day1 do
  @input "day1.txt"

  def part1(input \\ @input) do
    calculate_increases(0, input(input))
  end

  def part2(input \\ @input) do
    calculate_sliding_windows(0, input(input))
  end

  defp calculate_increases(increases, [_last | []]), do: increases

  defp calculate_increases(increases, [a | [b | _] = rest]) do
    case b > a do
      true -> calculate_increases(increases + 1, rest)
      _ -> calculate_increases(increases, rest)
    end
  end

  defp calculate_sliding_windows(increases, [a, _, _, b | []]) when b > a, do: increases + 1
  defp calculate_sliding_windows(increases, [_, _, _, _ | []]), do: increases

  defp calculate_sliding_windows(increases, [a | [_, _, b | _] = rest]) do
    case b > a do
      true -> calculate_sliding_windows(increases + 1, rest)
      _ -> calculate_sliding_windows(increases, rest)
    end
  end

  defp input(name) do
    name
    |> Aoc2021.Input.read_as_list()
    |> Enum.map(&String.to_integer/1)
  end
end
