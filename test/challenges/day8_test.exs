defmodule Aoc2021.Day8Test do
  use ExUnit.Case, async: true

  test "part1" do
    assert Aoc2021.Day8.part1("day8_example.txt") == 26
  end

  test "part2" do
    assert Aoc2021.Day8.part2("day8_example.txt") == 61229
  end
end
