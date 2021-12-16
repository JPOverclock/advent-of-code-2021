defmodule Aoc2021.Input do
  @input_path :code.priv_dir(:aoc2021)

  def read_as_stream(name), do: name |> file_path() |> File.stream!([], :line)

  def read_as_list(name) do
    name
    |> file_path()
    |> File.read!()
    |> String.split("\n", trim: true)
  end

  def read_raw(name) do
    name
    |> file_path()
    |> File.read!()
  end

  def read_raw_matrix(name) do
    name
    |> read_as_stream()
    |> Stream.map(&String.trim/1)
    |> Enum.map(fn line ->
      line
      |> String.split("", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
    |> List.to_tuple()
  end

  defp file_path(name), do: @input_path |> Path.join(name)
end
