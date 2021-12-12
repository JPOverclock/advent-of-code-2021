defmodule Aoc2021.Day7Test do
  use ExUnit.Case, async: true

  test "part1" do
    assert {_position, 37} = Aoc2021.Day7.part1("day7_example.txt")
  end

  test "part2" do
    assert {_position, 168} = Aoc2021.Day7.part2("day7_example.txt")
  end
end
