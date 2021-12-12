defmodule Aoc2021.Day11Test do
  use ExUnit.Case, async: true

  test "part1" do
    assert {_map, 1656} = Aoc2021.Day11.part1("day11_example.txt")
  end

  test "part2" do
    assert {195, _, _} = Aoc2021.Day11.part2("day11_example.txt")
  end
end
