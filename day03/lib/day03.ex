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
    file_to_claims(file_name)
    |> Enum.reduce(%{}, &map_inches/2)
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

      #iex> Day03.part2("data/day03.txt")
      #124

  """
  def part2(file_name) do
    999
  end

  private do
    defp file_to_claims(file_name) do
      re = ~r/#(\d+) @ (\d+),(\d+): (\d+)x(\d+)/

      File.stream!(file_name)
      |> Stream.map(&String.trim/1)
      |> Stream.map(&Regex.run(re, &1))
      # First result of regex is the whole string. Drop it.
      |> Stream.map(&Enum.drop(&1, 1))
      |> Stream.map(fn fields -> Enum.map(fields, &String.to_integer/1) end)
      |> Stream.map(fn [id, left, top, width, height] ->
        %Claim{id: id, left: left, top: top, width: width, height: height}
      end)
    end

    defp map_inches(claim, inches) do
      elements =
        for x <- claim.left..(claim.left + claim.width - 1),
            y <- claim.top..(claim.top + claim.height - 1),
            # {{2,3}, "902"} - {{square inch coordinates}, "claim id"}
            do: {{x, y}, claim.id}

      # inches is a map whose keys are coordinates and whose values
      # are lists of claim ids:
      # %{
      #   {2,3} => ["902"],
      #   {2,4} => ["902", "81"]
      # }
      Enum.reduce(elements, inches, fn {key, new_value}, inches ->
        case Map.fetch(inches, key) do
          {:ok, old_value} -> %{inches | key => [new_value | old_value]}
          :error -> Map.put_new(inches, key, [new_value])
        end
      end)
    end
  end
end
