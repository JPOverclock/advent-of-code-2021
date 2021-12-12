defmodule Aoc2021.Day12Test do
  use ExUnit.Case, async: true

  test "part1" do
    assert Aoc2021.Day12.part1("day12_example_small.txt") == 10
    assert Aoc2021.Day12.part1("day12_example_medium.txt") == 19
    assert Aoc2021.Day12.part1("day12_example_large.txt") == 226
  end

  test "part2" do
    assert Aoc2021.Day12.part2("day12_example_small.txt") == 36
    assert Aoc2021.Day12.part2("day12_example_medium.txt") == 103
    assert Aoc2021.Day12.part2("day12_example_large.txt") == 3509
  end
end
