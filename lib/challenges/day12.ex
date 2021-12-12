defmodule Aoc2021.Day12 do
  @input "day12.txt"

  def part1(input \\ @input) do
    input
    |> input()
    |> possible_paths("start", [])
    |> Enum.count()
  end

  def part2(input \\ @input) do
    graph = input(input)

    small_caves = graph
    |> Map.keys()
    |> Enum.filter(fn key -> key != "start" and key != "end" end)
    |> Enum.filter(&is_small_cave?/1)

    [nil | small_caves]
    |> Enum.flat_map(fn cave -> possible_paths_with_revisit(graph, "start", [], cave) end)
    |> Enum.uniq()
    |> Enum.count()
  end

  defp possible_paths(_graph, "end" = node, path), do: [[node | path] |> Enum.reverse()]
  defp possible_paths(graph, node, path) do
    %{^node => edges} = graph

    edges
    |> Enum.reject(fn edge -> is_small_cave?(edge) and Enum.member?(path, edge) end)
    |> Enum.flat_map(fn edge ->
      possible_paths(graph, edge, [node | path])
    end)
  end

  defp possible_paths_with_revisit(_graph, "end" = node, path, _), do: [[node | path] |> Enum.reverse()]
  defp possible_paths_with_revisit(graph, node, path, allowed_cave) do
    %{^node => edges} = graph

    edges
    |> Enum.reject(fn edge ->
      count = path
      |> Enum.filter(fn e -> e == edge end)
      |> Enum.count()

      is_small_cave?(edge)
      and count != 0
      and ((allowed_cave == edge and count == 2)
        or (allowed_cave != edge and count == 1))
    end)
    |> Enum.flat_map(fn edge ->
      possible_paths_with_revisit(graph, edge, [node | path], allowed_cave)
    end)
  end

  defp is_small_cave?(edge), do: String.downcase(edge) == edge

  defp input(filename) do
    filename
    |> Aoc2021.Input.read_as_stream()
    |> Enum.map(&String.trim/1)
    |> Enum.map(fn line -> String.split(line, "-", trim: true) end)
    |> Enum.map(fn [node, edge] -> {node, edge} end)
    |> Enum.reduce(%{}, fn {node, edge}, map ->
      map
      |> Map.update(node, [edge], fn edges -> [edge | edges] end)
      |> Map.update(edge, [node], fn edges -> [node | edges] end)
    end)
  end
end
