defmodule Aoc2021.Day15Test do
  use ExUnit.Case, async: true

  test "part1" do
    assert Aoc2021.Day15.part1("day15_example.txt") == 40
  end

  test "part2" do
    assert Aoc2021.Day15.part2("day15_example.txt") == 315
  end
end
