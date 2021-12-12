defmodule Aoc2021.Day5Test do
  use ExUnit.Case, async: true

  test "part1" do
    assert Aoc2021.Day5.part1("day5_example.txt") == 5
  end

  test "part2" do
    assert Aoc2021.Day5.part2("day5_example.txt") == 12
  end
end
