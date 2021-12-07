defmodule Aoc2021.Day4 do
  @input "day4.txt"

  def part1(input \\ @input) do
    {numbers, boards} = input(input)
    play(boards, numbers, [])
  end

  def part2(input \\ @input) do
    {numbers, boards} = input(input)
    play_to_lose(boards, numbers, [])
  end

  defp play(_boards, [], _), do: {:ok, "no winners..."}

  defp play(boards, [current_number | rest], selected_numbers) do
    played_numbers = [current_number | selected_numbers]

    winning_board =
      boards
      |> Enum.filter(fn board -> winning_board?(board, played_numbers) end)

    case winning_board do
      [board | _] ->
        {:ok,
         {current_number, selected_numbers, board,
          board_score(board, played_numbers, current_number)}}

      _ ->
        play(boards, rest, played_numbers)
    end
  end

  defp play_to_lose(boards, [current_number | rest], selected_numbers) do
    played_numbers = [current_number | selected_numbers]

    remaining_boards =
      boards
      |> Enum.filter(fn board -> !winning_board?(board, played_numbers) end)

    case remaining_boards do
      [] ->
        [board | _] = boards

        {:ok,
         {current_number, selected_numbers, board,
          board_score(board, played_numbers, current_number)}}

      _ ->
        play_to_lose(remaining_boards, rest, played_numbers)
    end
  end

  defp input(filename) do
    raw =
      filename
      |> Aoc2021.Input.read_raw()
      |> String.split("\n\n", trim: true)

    [numbers | boards] = raw

    numbers = numbers |> String.split(",", trim: true) |> Enum.map(&String.to_integer/1)
    boards = boards |> Enum.map(&make_board/1)

    {numbers, boards}
  end

  defp make_board(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      String.split(line, " ", trim: true) |> Enum.map(&String.to_integer/1)
    end)
  end

  defp winning_board?(board, numbers) do
    any_line? =
      board
      |> board_lines()
      |> Enum.any?(fn line ->
        line |> Enum.all?(fn number -> Enum.member?(numbers, number) end)
      end)

    any_column? =
      board
      |> board_columns()
      |> Enum.any?(fn line ->
        line |> Enum.all?(fn number -> Enum.member?(numbers, number) end)
      end)

    any_line? or any_column?
  end

  defp board_score(board, numbers, current_number) do
    sum =
      board
      |> Enum.flat_map(fn number -> number end)
      |> Enum.filter(fn number -> !Enum.member?(numbers, number) end)
      |> Enum.sum()

    sum * current_number
  end

  defp board_lines(board), do: board

  defp board_columns(board) do
    0..(Enum.count(board) - 1)
    |> Enum.map(fn idx -> board |> Enum.map(fn line -> Enum.at(line, idx) end) end)
  end
end
