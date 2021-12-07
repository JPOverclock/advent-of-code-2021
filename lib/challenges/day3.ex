defmodule Aoc2021.Day3 do
  @input "day3.txt"

  def part1(input \\ @input) do
    input = input(input)
    count = Enum.count(input)

    counts =
      1..Enum.count(Enum.at(input, 0))
      |> Enum.map(fn _ -> 0 end)

    bits =
      input
      |> count_bits(counts)
      |> Enum.map(fn bit_count ->
        case bit_count >= count / 2 do
          true -> 1
          false -> 0
        end
      end)

    gamma = bits_to_integer(bits)
    epsilon = bits |> Enum.map(&reverse_bit/1) |> bits_to_integer()

    gamma * epsilon
  end

  def part2(input \\ @input) do
    input = input(input)

    oxigen_generator =
      input
      |> filter_bits(0, fn sum, numbers -> sum >= Enum.count(numbers) / 2 end)
      |> bits_to_integer()

    carbon_scrubber =
      input
      |> filter_bits(0, fn sum, numbers -> sum < Enum.count(numbers) / 2 end)
      |> bits_to_integer()

    oxigen_generator * carbon_scrubber
  end

  defp filter_bits([number], _position, _filter_function), do: number

  defp filter_bits(numbers, position, filter_function) do
    sum =
      numbers
      |> count_ones_at_position(position)

    rest =
      case filter_function.(sum, numbers) do
        true -> Enum.filter(numbers, fn b -> Enum.at(b, position) == 1 end)
        false -> Enum.filter(numbers, fn b -> Enum.at(b, position) == 0 end)
      end

    filter_bits(rest, position + 1, filter_function)
  end

  defp count_ones_at_position(bits, position) do
    bits
    |> Enum.map(&Enum.at(&1, position))
    |> Enum.sum()
  end

  defp reverse_bit(0), do: 1
  defp reverse_bit(1), do: 0

  def count_bits([], bits), do: bits

  def count_bits([binary | rest], accumulator) do
    count_bits(
      rest,
      Enum.zip_with(binary, accumulator, &(&1 + &2))
    )
  end

  defp bits_to_integer(bits), do: bits |> Enum.join("") |> String.to_integer(2)

  defp input(filename) do
    filename
    |> Aoc2021.Input.read_as_stream()
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.codepoints/1)
    |> Stream.map(fn bin -> Enum.map(bin, fn number -> String.to_integer(number) end) end)
    |> Enum.to_list()
  end
end
