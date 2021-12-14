defmodule Aoc2021.Day14 do
  @input "day14.txt"

  def part1(input \\ @input, iterations \\ 10) do
    {template, formulae} = input
    |> input()

    polymer = 1..iterations
    |> Enum.reduce(template, fn _, chain ->
      chain
      |> build_polymer(formulae, [])
    end)

    {{_, min}, {_, max}} = polymer
    |> Enum.frequencies()
    |> Enum.min_max_by(fn {_, amount} -> amount end)

    max - min
  end

  def part2(input \\ @input, iterations \\ 40) do
    {template, formulae} = input
    |> input()

    {polymer, counts} = build_initial_polymer(template, [], %{})

    {polymers, adjustment} = polymer
    |> Enum.map(fn poly -> {poly, 1} end)
    |> expand_polymer(formulae, counts, 0, iterations)

    {{_, min}, {_, max}} = polymers
    |> Enum.flat_map(fn {[a,b], count} -> [{a, count}, {b, count}] end)
    |> Enum.group_by(fn {e, _} -> e end, fn {_, count} -> count end)
    |> Enum.map(fn {elem, counts} -> {elem, Enum.sum(counts) - adjustment[elem]} end)
    |> Enum.min_max_by(fn {_, amount} -> amount end)

    max - min
  end

  defp build_polymer([a | []], _formulae, result) do
    [[a] | result]
    |> Enum.reverse()
    |> Enum.flat_map(&(&1))
  end

  defp build_polymer([a | [b | _] = rest], formulae, result) do
    build_polymer(rest, formulae, [[a, formulae[[a,b]]] | result])
  end

  defp build_initial_polymer([a | [b | []]], result, adjustment), do: {Enum.reverse([[a,b] | result]), adjustment}
  defp build_initial_polymer([a | [b | _] = rest], result, adjustment) do
    build_initial_polymer(rest, [[a,b] | result], Map.update(adjustment, b, 1, fn x -> x + 1 end))
  end

  defp expand_polymer(polymers, _formulae, adjustment, iteration, iteration), do: {polymers, adjustment}
  defp expand_polymer(polymers, formulae, adjustment, iteration, iterations) do
    {new_adjustment, new_polymers} = polymers
    |> Enum.reduce({adjustment, %{}}, fn {polymer, count}, {adjustment, polymers} ->
      [[_, e] = poly_a, [e, _] = poly_b] = expand(polymer, formulae)

      new_polymers = polymers
      |> Map.update(poly_a, count, fn x -> x + count end)
      |> Map.update(poly_b, count, fn x -> x + count end)

      new_adjustment = adjustment
      |> Map.update(e, count, fn x -> x + count end)

      {new_adjustment, new_polymers}
    end)

    expand_polymer(new_polymers, formulae, new_adjustment, iteration + 1, iterations)
  end

  defp expand([a,b] = template, formulae) do
    with %{^template => result} <- formulae do
      [[a, result], [result, b]]
    end
  end

  defp input(filename) do
    [template_part, formulae_part] = filename
    |> Aoc2021.Input.read_raw()
    |> String.trim()
    |> String.split("\n\n", trim: true)

    template = template_part
    |> String.split("", trim: true)

    formulae = formulae_part
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> String.split(line, " -> ", trim: true) end)
    |> Enum.map(fn [pattern, insertion] ->
      {pattern |> String.split("", trim: true), insertion}
    end)
    |> Map.new()

    {template, formulae}
  end
end
