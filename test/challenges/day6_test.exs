defmodule Aoc2021.Day6Test do
  use ExUnit.Case, async: true

  test "part1" do
    assert Aoc2021.Day6.part1("day6_example.txt") == 5934
  end

  test "part2" do
    assert Aoc2021.Day6.part2("day6_example.txt") == 26_984_457_539
  end
end
