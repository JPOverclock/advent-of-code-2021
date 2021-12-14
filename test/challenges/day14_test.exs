defmodule Aoc2021.Day14Test do
  use ExUnit.Case, async: true

  test "part1" do
    assert Aoc2021.Day14.part1("day14_example.txt") == 1588
  end

  test "part2" do
    assert Aoc2021.Day14.part2("day14_example.txt") == 2188189693529
  end
end
