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
      8715

  """
  def part1(file_name) do
    claims = file_to_claims(file_name)
    inches = Enum.reduce(claims, %{}, &map_inches/2)
    vals = Map.values(inches)
    two_or_more = Enum.filter(vals, &(length(&1) > 1))
    length(two_or_more)
    # 999
  end

  private do
    defp file_to_claims(file_name) do
      re = ~r/#(\d+) @ (\d+),(\d+): (\d+)x(\d+)/

      File.stream!(file_name)
      |> Stream.map(&String.trim/1)
      |> Stream.map(&Regex.run(re, &1))
      |> Enum.map(fn [_, id, left, top, width, height] ->
        %Claim{
          id: id,
          left: String.to_integer(left),
          top: String.to_integer(top),
          width: String.to_integer(width),
          height: String.to_integer(height)
        }
      end)
    end

    defp map_inches(claim, inches) do
      elements =
        for x <- claim.left..(claim.left + claim.width - 1),
            y <- claim.top..(claim.top + claim.height - 1),
            do: {{x, y}, claim.id}

      Enum.reduce(elements, inches, fn {key, new_value}, inches ->
        Map.update(inches, key, [new_value], fn old_value -> [new_value | old_value] end)
      end)
    end
  end
end
