defmodule Aoc2021.Day10Test do
  use ExUnit.Case, async: true

  test "part1" do
    assert Aoc2021.Day10.part1("day10_example.txt") == 26397
  end

  test "part2" do
    assert Aoc2021.Day10.part2("day10_example.txt") == 288957
  end
end
