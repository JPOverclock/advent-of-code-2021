defmodule Aoc2021.Day4Test do
  use ExUnit.Case

  test "part1" do
    assert {:ok, {_iterations, _numbers, _board, 4512}} = Aoc2021.Day4.part1("day4_example.txt")
  end

  test "part2" do
    assert {:ok, {_iterations, _numbers, _board, 1924}} = Aoc2021.Day4.part2("day4_example.txt")
  end
end
