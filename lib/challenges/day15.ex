defmodule Aoc2021.Day15 do
  @input "day15.txt"

  def part1(input \\ @input) do
    {{width, height}, g} = graph = input(input)

    graph
    |> find_path({{width - 1, height - 1}, Map.get(g, {width - 1, height - 1})}, [[{{0,0}, 0}]], %{})
    |> Enum.reduce(0, fn {point, _}, acc ->
      case point do
        {0,0} -> acc
        point -> acc + Map.get(g, point)
      end
    end)
  end

  def part2(input \\ @input) do
    {{width, height}, g} = graph = input(input) |> expand_graph(5)

    graph
    |> find_path({{width - 1, height - 1}, Map.get(g, {width - 1, height - 1})}, [[{{0,0}, 0}]], %{})
    |> Enum.reduce(0, fn {point, _}, acc ->
      case point do
        {0,0} -> acc
        point -> acc + Map.get(g, point)
      end
    end)
  end

  defp find_path(_, {goal, _}, [[{goal, _} | _] = path | _], _), do: path
  defp find_path(graph, {goal_coordinates, _} = goal, [[{coordinates, f_value} | _] = path | rest], visited) do
    new_set = graph
    |> neighbours(coordinates)
    |> Enum.map(fn {successor_point, cost} -> [{successor_point, cost + f_value} | path] end)
    |> Enum.reject(fn [{point, cost} | _] ->
      case visited do
        %{^point => {_, existing_cost}} -> existing_cost < cost
        _ -> false
      end
    end)
    |> Enum.concat(rest)
    |> Enum.reduce(%{}, fn [{p, cost} | path], map ->
      Map.update(map, p, {cost, path}, fn {existing_cost, existing_path} ->
        case existing_cost < cost do
          true -> {existing_cost, existing_path}
          false -> {cost, path}
        end
      end)
    end)
    |> Enum.map(fn {point, {cost, path}} -> [{point, cost} | path] end)
    |> Enum.sort_by(fn [{coordinates, cost} | _] -> cost + heuristic(coordinates, goal_coordinates) end)

    new_visited = new_set
    |> Enum.reduce(visited, fn [{point, cost} | _] = path, v ->
      Map.put(v, point, {path, cost})
    end)

    find_path(graph, goal, new_set, new_visited)
  end

  defp neighbours({_, graph}, {x, y}) do
    [{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}]
    |> Enum.map(&({&1, Map.get(graph, &1)}))
    |> Enum.reject(fn {_, v} -> v == nil end)
  end

  defp heuristic({x,y}, {x_end, y_end}), do: abs(x_end - x) + abs(y_end - y)

  def expand_graph({{width, height}, map}, times) do
    actions = for x <- 0..width - 1,
        y <- 0..height - 1,
        i <- 0..(times - 1),
        j <- 0..(times - 1), do: {{x,y}, {x + i * width, y + j * height}, i + j}

    new_map = actions
    |> Enum.reduce(%{}, fn {origin, destination, increment}, m ->
      value = Map.get(map, origin) + increment
      value = cond do
        value > 9 -> value - 9
        true -> value
      end

      Map.put(m, destination, value)
    end)

    {{width * times, height * times}, new_map}
  end

  defp input(filename) do
    matrix = filename
    |> Aoc2021.Input.read_raw_matrix()

    height = matrix |> tuple_size()
    width = matrix |> elem(0) |> tuple_size()

    points = for y <- 0..height - 1,
        x <- 0..width - 1, do: {{x,y}, matrix |> elem(y) |> elem(x)}

    {{width, height}, Map.new(points)}
  end
end
