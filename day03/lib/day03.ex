defmodule Day03 do
  @moduledoc """
  Advent of Code 2018, day 3.
  """

  use Private

  defmodule Claim do
    defstruct id: nil, left: nil, top: nil, width: nil, height: nil
  end

  @doc """
  How many square inches of fabric are within two or more claims?

  ## Examples

      iex> Day03.part1("data/day03.txt")
      109716

  """
  def part1(file_name) do
    file_to_inches_map(file_name)
    # Get the values out of the inches map.
    # Each value is a list of claim id's.
    |> Map.values()
    # Filter out the single-id lists.
    |> Enum.filter(&(length(&1) > 1))
    # The length of the resulting list is the
    # number of square inches with multiple claims.
    |> length
  end

  @doc """
  What is the ID of the only claim that doesn't overlap?

  ## Examples

      iex> Day03.part2("data/day03.txt")
      124

  """
  def part2(file_name) do
    m =
      file_to_inches_map(file_name)
      # Get the values out of the inches map.
      # Each value is a list of claim id's.
      |> Map.values()
      # Separate single-id lists from multi-id lists
      |> Enum.group_by(&(length(&1) == 1))

    single_ids = m.true |> List.flatten() |> MapSet.new()
    multi_ids = m.false |> List.flatten() |> MapSet.new()
    # ids can be in both lists. The one difference is the answer.
    MapSet.difference(single_ids, multi_ids)
    |> MapSet.to_list()
    |> hd()
  end

  private do
    # The inches map has keys that are square inch coordinates and
    # values that are lists of claim ids that contain the key:
    # %{
    #   {2,3} => ["902"],
    #   {2,4} => ["902", "81"]
    # }
    defp file_to_inches_map(file_name) do
      re = ~r/#(\d+) @ (\d+),(\d+): (\d+)x(\d+)/

      File.stream!(file_name)
      |> Stream.map(&String.trim/1)
      # Capture just the matching fields, not the matching part of the string
      |> Stream.map(&Regex.run(re, &1, capture: :all_but_first))
      |> Stream.map(fn fields -> Enum.map(fields, &String.to_integer/1) end)
      |> Stream.map(fn [id, left, top, width, height] ->
        %Claim{id: id, left: left, top: top, width: width, height: height}
      end)
      |> Enum.reduce(%{}, &map_inches/2)
    end

    defp map_inches(claim, inches) do
      elements =
        for x <- claim.left..(claim.left + claim.width - 1),
            y <- claim.top..(claim.top + claim.height - 1),
            # {{2,3}, "902"} - {{square inch coordinates}, "claim id"}
            do: {{x, y}, claim.id}

      Enum.reduce(elements, inches, fn {key, new_value}, inches ->
        case Map.fetch(inches, key) do
          {:ok, old_value} -> %{inches | key => [new_value | old_value]}
          :error -> Map.put_new(inches, key, [new_value])
        end
      end)
    end
  end
end
