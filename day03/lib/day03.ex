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
    999
  end

  private do
    defp file_to_claims(file_name) do
      re = ~r/#(\d+) @ (\d+),(\d+): (\d+)x(\d+)/

      File.stream!(file_name)
      |> Stream.map(&String.trim/1)
      |> Stream.map(&Regex.run(re, &1))
      |> Enum.map(fn [_, id, left, top, width, height] ->
        %Claim{id: id, left: left, top: top, width: width, height: height}
      end)
    end
  end
end
