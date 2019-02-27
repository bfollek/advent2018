defmodule Day01 do
  @moduledoc """
  Advent of Code 2018, day 1.
  """

  @doc """
  part1_v1 reads the data and keeps a running tally of the numbers, starting from zero.

  ## Examples

      iex> Day01.part1_v1("data/day01.txt")
      592

  """

  def part1_v1(file_name) do
    File.stream!(file_name)
    |> Enum.reduce(0, &(line_to_int(&1) + &2))
  end

  defp line_to_int(line) do
    line
    |> String.trim()
    |> String.to_integer()
  end

  @doc """
  part1_v2 reads the data and keeps a running tally of the numbers, starting from zero.

  Pipes within pipes, to avoid the helper func. Plumbing nightmare.

  ## Examples

      iex> Day01.part1_v2("data/day01.txt")
      592

  """

  def part1_v2(file_name) do
    File.stream!(file_name)
    |> Enum.reduce(0, &(&1 |> String.trim() |> String.to_integer() |> Kernel.+(&2)))
  end
end
