defmodule Day01 do
  @moduledoc """
  Advent of Code 2018, day 1.
  """

  @doc """
  part1 reads the data and keeps a running tally of the numbers, starting from zero.

  ## Examples

      iex> Day01.part1("data/day01.txt")
      592

  """

  def part1(file_name) do
    File.stream!(file_name)
    |> Enum.reduce(0, &(line_to_int(&1) + &2))
  end

  defp line_to_int(line) do
    line
    |> String.trim()
    |> String.to_integer()
  end
end
