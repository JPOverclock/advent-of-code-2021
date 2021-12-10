defmodule Aoc2021.Day10 do
  @input "day10.txt"

  def part1(input \\ @input) do
    input
    |> input()
    |> Enum.map(fn line -> check_syntax(line, []) end)
    |> Enum.filter(fn {status, _} -> status == :error end)
    |> Enum.map(fn {_, {error, _, _}} -> score_error(error) end)
    |> Enum.sum()
  end

  def part2(input \\ @input) do
    scores = input
    |> input()
    |> Enum.map(fn line -> check_syntax(line, []) end)
    |> Enum.filter(fn {status, _} -> status == :incomplete end)
    |> Enum.map(fn {_, stack} -> score_autocomplete(stack, 0) end)
    |> Enum.sort()

    Enum.at(scores, div(Enum.count(scores),2))
  end

  defp check_syntax([], []), do: {:ok, :complete}
  defp check_syntax([], stack), do: {:incomplete, stack}

  defp check_syntax(["}" = got | _], ["(" | _] = stack), do: {:error, {got, ")", stack}}
  defp check_syntax(["}" = got | _], ["[" | _] = stack), do: {:error, {got, "]", stack}}
  defp check_syntax(["}" = got | _], ["<" | _] = stack), do: {:error, {got, ">", stack}}
  defp check_syntax(["]" = got | _], ["(" | _] = stack), do: {:error, {got, ")", stack}}
  defp check_syntax(["]" = got | _], ["{" | _] = stack), do: {:error, {got, "}", stack}}
  defp check_syntax(["]" = got | _], ["<" | _] = stack), do: {:error, {got, ">", stack}}
  defp check_syntax([">" = got | _], ["(" | _] = stack), do: {:error, {got, ")", stack}}
  defp check_syntax([">" = got | _], ["{" | _] = stack), do: {:error, {got, "}", stack}}
  defp check_syntax([">" = got | _], ["[" | _] = stack), do: {:error, {got, "]", stack}}
  defp check_syntax([")" = got | _], ["[" | _] = stack), do: {:error, {got, "]", stack}}
  defp check_syntax([")" = got | _], ["{" | _] = stack), do: {:error, {got, "}", stack}}
  defp check_syntax([")" = got | _], ["<" | _] = stack), do: {:error, {got, ">", stack}}

  defp check_syntax([")" | rest], ["(" | stack]), do: check_syntax(rest, stack)
  defp check_syntax(["]" | rest], ["[" | stack]), do: check_syntax(rest, stack)
  defp check_syntax(["}" | rest], ["{" | stack]), do: check_syntax(rest, stack)
  defp check_syntax([">" | rest], ["<" | stack]), do: check_syntax(rest, stack)

  defp check_syntax([got | rest], stack), do: check_syntax(rest, [got | stack])

  defp score_error(")"), do: 3
  defp score_error("]"), do: 57
  defp score_error("}"), do: 1197
  defp score_error(">"), do: 25137

  defp score_autocomplete([], score), do: score

  defp score_autocomplete(["(" | rest], score), do: score_autocomplete(rest, (score * 5) + 1)
  defp score_autocomplete(["[" | rest], score), do: score_autocomplete(rest, (score * 5) + 2)
  defp score_autocomplete(["{" | rest], score), do: score_autocomplete(rest, (score * 5) + 3)
  defp score_autocomplete(["<" | rest], score), do: score_autocomplete(rest, (score * 5) + 4)

  defp input(filename) do
    filename
    |> Aoc2021.Input.read_as_stream()
    |> Stream.map(&String.trim/1)
    |> Enum.map(fn line -> String.split(line, "", trim: true) end)
  end
end
