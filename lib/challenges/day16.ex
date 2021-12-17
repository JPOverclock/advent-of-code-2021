defmodule Aoc2021.Day16 do
  def part1(input) do
    input
    |> Base.decode16!()
    |> parse()
    |> sum_versions()
  end

  def part2(input) do
    input
    |> Base.decode16!()
    |> parse()
    |> evaluate()
  end

  defp sum_versions({:operator, version, _, _, parts}) do
    parts
    |> Enum.reduce(version, fn part, accum -> accum + sum_versions(part) end)
  end

  defp sum_versions({:literal, version, _, _, _}), do: version

  defp evaluate({:literal, _, _, _, value}), do: value
  defp evaluate({:operator, _, type, _, parts}) do
    operator = case type do
      0 -> fn (a,b) -> a + b end
      1 -> fn (a,b) -> a * b end
      2 -> fn (a,b) -> min(a,b) end
      3 -> fn (a,b) -> max(a,b) end
      5 -> fn (a,b) ->
        cond do
          a > b -> 1
          true -> 0
        end
      end
      6 -> fn (a,b) ->
        cond do
          a < b -> 1
          true -> 0
        end
      end
      7 -> fn (a,b) ->
        cond do
          a == b -> 1
          true -> 0
        end
      end
    end

    parts
    |> Enum.map(&evaluate/1)
    |> Enum.reduce(operator)
  end

  defp parse(<<version::3, 4::3, rest::bitstring>>) do
    literal = parse_literal(rest)
    literal_size = div(bit_size(literal), 4) * 5

    <<_literal::size(literal_size), remaining::bitstring>> = <<rest::bitstring>>

    {:literal, version, 4, {literal_size + 6, remaining}, literal_to_integer(literal)}
  end

  defp parse(<<version::3, type::3, rest::bitstring>>) do
    {parts, rest, size} = parse_operator(type, rest)
    {:operator, version, type, {size + 6, rest}, parts}
  end

  defp parse_literal(<<0::1, number::4, _::bitstring>>) do
    <<number::4>>
  end

  defp parse_literal(<<1::1, number::4, rest::bitstring>>) do
    <<number::4, parse_literal(rest)::bitstring>>
  end

  defp literal_to_integer(literal) do
    pad_length = 8 - rem(bit_size(literal), 8)
    :binary.decode_unsigned(<<0::size(pad_length), literal::bitstring>>)
  end

  defp parse_operator(_, <<0::1, total_length::15, rest::bitstring>>) do
    {parts, rest, size} = parse_operator_with_size(0, total_length, [], rest)
    {parts, rest, size + 16}
  end

  defp parse_operator(_, <<1::1, number_of_packets::11, rest::bitstring>>) do
    {parts, rest, size} = parse_operator_with_packets(0, number_of_packets, [], rest)
    {parts, rest, size + 12}
  end

  defp parse_operator_with_size(length, total_length, parts, rest) when length >= total_length do
    {parts, rest, total_length}
  end

  defp parse_operator_with_size(length, total_length, parts, rest) do
    {_, _, _, {size, _}, _} = part = parse(rest)
    <<_::size(size), remainder::bitstring>> = rest
    parse_operator_with_size(length + size, total_length, [part | parts], remainder)
  end

  defp parse_operator_with_packets(packets, number_of_packets, parts, rest) when packets >= number_of_packets do
    {parts, rest, parts |> Enum.map(fn {_, _, _, {size, _}, _} -> size end) |> Enum.sum()}
  end

  defp parse_operator_with_packets(packets, number_of_packets, parts, rest) do
    {_, _, _, {size, _}, _} = part = parse(rest)
    <<_::size(size), remainder::bitstring>> = rest
    parse_operator_with_packets(packets + 1, number_of_packets, [part | parts], remainder)
  end
end
