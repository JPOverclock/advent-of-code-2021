defmodule Aoc2021.Day8 do
  @input "day8.txt"

  @digit_0 ["a", "b", "c", "e", "f", "g"]
  @digit_1 ["c", "f"]
  @digit_2 ["a", "c", "d", "e", "g"]
  @digit_3 ["a", "c", "d", "f", "g"]
  @digit_4 ["b", "c", "d", "f"]
  @digit_5 ["a", "b", "d", "f", "g"]
  @digit_6 ["a", "b", "d", "e", "f", "g"]
  @digit_7 ["a", "c", "f"]
  @digit_8 ["a", "b", "c", "d", "e", "f", "g"]
  @digit_9 ["a", "b", "c", "d", "f", "g"]

  def part1(input \\ @input) do
    input
    |> input()
    |> Enum.flat_map(fn {_combinations, output} -> output end)
    |> Enum.filter(fn segments ->
      case Enum.count(segments) do
        # Digit 1
        2 -> true
        # Digit 7
        3 -> true
        # Digit 4
        4 -> true
        # Digit 8
        7 -> true
        _ -> false
      end
    end)
    |> Enum.count()
  end

  def part2(input \\ @input) do
    input
    |> input()
    |> Enum.map(&deduce_sequence/1)
    |> Enum.sum()
  end

  defp deduce_sequence({input, output}) do
    all_sequences = input ++ output

    [mapping] =
      possible_mappings()
      |> deduce_mappings(all_sequences)
      |> Enum.filter(fn mapping -> try_mapping(mapping, all_sequences) end)

    output
    |> Enum.map(fn number -> map_number(number, mapping) end)
    |> Enum.join()
    |> String.to_integer()
  end

  defp try_mapping(mapping, sequences) do
    sequences
    |> Enum.map(fn number -> map_number(number, mapping) end)
    |> Enum.all?(&(&1 != -1))
  end

  defp deduce_mappings(mappings, []), do: mappings

  defp deduce_mappings([_mapping] = mappings, _), do: mappings

  defp deduce_mappings(mappings, [[c, f] | rest]) do
    new_mappings =
      mappings
      |> Enum.filter(fn mapping ->
        case mapping do
          %{^c => "c"} -> true
          %{^c => "f"} -> true
          %{^f => "c"} -> true
          %{^f => "f"} -> true
          _ -> false
        end
      end)

    deduce_mappings(new_mappings, rest)
  end

  defp deduce_mappings(mappings, [[a, c, f] | rest]) do
    new_mappings =
      mappings
      |> Enum.filter(fn mapping ->
        case mapping do
          %{^a => "a"} -> true
          %{^a => "c"} -> true
          %{^a => "f"} -> true
          %{^c => "a"} -> true
          %{^c => "c"} -> true
          %{^c => "f"} -> true
          %{^f => "a"} -> true
          %{^f => "c"} -> true
          %{^f => "f"} -> true
          _ -> false
        end
      end)

    deduce_mappings(new_mappings, rest)
  end

  defp deduce_mappings(mappings, [[b, c, d, f] | rest]) do
    new_mappings =
      mappings
      |> Enum.filter(fn mapping ->
        case mapping do
          %{^b => "b"} -> true
          %{^b => "c"} -> true
          %{^b => "d"} -> true
          %{^b => "f"} -> true
          %{^c => "b"} -> true
          %{^c => "c"} -> true
          %{^c => "d"} -> true
          %{^c => "f"} -> true
          %{^d => "b"} -> true
          %{^d => "c"} -> true
          %{^d => "d"} -> true
          %{^d => "f"} -> true
          %{^f => "b"} -> true
          %{^f => "c"} -> true
          %{^f => "d"} -> true
          %{^f => "f"} -> true
          _ -> false
        end
      end)

    deduce_mappings(new_mappings, rest)
  end

  defp deduce_mappings(mappings, [_ | rest]), do: deduce_mappings(mappings, rest)

  defp map_number(number, mapping) do
    number
    |> Enum.map(fn segment -> mapping[segment] end)
    |> Enum.sort()
    |> to_digit()
  end

  defp to_digit(@digit_0), do: 0
  defp to_digit(@digit_1), do: 1
  defp to_digit(@digit_2), do: 2
  defp to_digit(@digit_3), do: 3
  defp to_digit(@digit_4), do: 4
  defp to_digit(@digit_5), do: 5
  defp to_digit(@digit_6), do: 6
  defp to_digit(@digit_7), do: 7
  defp to_digit(@digit_8), do: 8
  defp to_digit(@digit_9), do: 9
  defp to_digit(_), do: -1

  defp possible_mappings() do
    # all segments lit up
    segments = @digit_8

    # Generate mappings for all permutations
    segments
    |> permutations()
    |> Enum.map(fn permutation ->
      permutation
      |> Enum.zip_with(segments, fn k, v -> {k, v} end)
      |> Map.new()
    end)
  end

  defp permutations([]), do: [[]]

  defp permutations(list),
    do: for(elem <- list, rest <- permutations(list -- [elem]), do: [elem | rest])

  defp input(filename) do
    filename
    |> Aoc2021.Input.read_as_stream()
    |> Stream.map(&String.trim/1)
    |> Stream.map(fn line -> String.split(line, " | ", trim: true) end)
    |> Enum.map(fn [combinations, output] -> {parse(combinations), parse(output)} end)
  end

  defp parse(segments) do
    segments
    |> String.split(" ", trim: true)
    |> Enum.map(fn segments -> String.split(segments, "", trim: true) end)
  end
end
