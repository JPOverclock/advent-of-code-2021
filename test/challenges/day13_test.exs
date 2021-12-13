defmodule Aoc2021.Day13Test do
  use ExUnit.Case, async: true

  test "part1" do
    assert Aoc2021.Day13.part1("day13_example.txt") == 17
  end

  test "part2" do
    assert Aoc2021.Day13.part2("day13_example.txt") == [
      ["#", "#", "#", "#", "#"],
      ["#", " ", " ", " ", "#"],
      ["#", " ", " ", " ", "#"],
      ["#", " ", " ", " ", "#"],
      ["#", "#", "#", "#", "#"]
    ]
  end
end
