defmodule Aoc2021.Day3 do

  def part1() do
    input = input()
    count = Enum.count(input)

    bits = input
    |> count_bits({0,0,0,0,0,0,0,0,0,0,0,0})
    |> Tuple.to_list()
    |> Enum.map(fn bit_count ->
      case bit_count >= count / 2 do
        true -> 1
        false -> 0
      end
    end)

    gamma = bits |> Enum.join("") |> String.to_integer(2)
    epsilon = bits |> Enum.map(&reverse_bit/1) |> Enum.join("") |> String.to_integer(2)

    gamma * epsilon
  end

  def part2() do
    input = input()

    oxigen_generator = input |> find_most_significant(0) |> Tuple.to_list() |> Enum.join("") |> String.to_integer(2)
    carbon_scrubber = input |> find_least_significant(0) |> Tuple.to_list() |> Enum.join("") |> String.to_integer(2)

    oxigen_generator * carbon_scrubber
  end

  def find_most_significant([number], _position), do: number
  def find_most_significant(numbers, position) do
    sum = numbers
    |> count_ones_at_position(position)

    rest = case sum >= (Enum.count(numbers) / 2) do
      true -> Enum.filter(numbers, fn b -> elem(b, position) == 1 end)
      false -> Enum.filter(numbers, fn b -> elem(b, position) == 0 end)
    end

    find_most_significant(rest, position + 1)
  end

  def find_least_significant([number], _position), do: number
  def find_least_significant(numbers, position) do
    sum = numbers
    |> count_ones_at_position(position)

    rest = case sum >= (Enum.count(numbers) / 2) do
      true -> Enum.filter(numbers, fn b -> elem(b, position) == 0 end)
      false -> Enum.filter(numbers, fn b -> elem(b, position) == 1 end)
    end

    find_least_significant(rest, position + 1)
  end

  def count_ones_at_position(bits, position) do
    bits
    |> Enum.map(fn bin -> elem(bin, position) end)
    |> Enum.sum()
  end

  def reverse_bit(0), do: 1
  def reverse_bit(1), do: 0

  def count_bits([], bits), do: bits
  def count_bits([{a,b,c,d,e,f,g,h,i,j,k,l} | rest], {aa,bb,cc,dd,ee,ff,gg,hh,ii,jj,kk,ll}) do
    count_bits(
      rest,
      {aa+a, bb+b, cc+c, dd+d, ee+e, ff+f, gg+g, hh+h, ii+i, jj+j, kk+k, ll+l}
    )
  end

  defp input() do
    "day3.txt"
    |> Aoc2021.Input.read_as_stream()
    |> Stream.map(&String.trim/1)
    |> Stream.map(fn str -> String.pad_leading(str, 12, "0") end)
    |> Stream.map(&String.codepoints/1)
    |> Stream.map(fn bin -> Enum.map(bin, fn number -> String.to_integer(number) end) end)
    |> Stream.map(&List.to_tuple/1)
    |> Enum.to_list()
  end
end
