defmodule Aoc2021.Day3Test do
  use ExUnit.Case, async: true

  test "part1" do
    assert Aoc2021.Day3.part1("day3_example.txt") == 198
  end

  test "part2" do
    assert Aoc2021.Day3.part2("day3_example.txt") == 230
  end
end
