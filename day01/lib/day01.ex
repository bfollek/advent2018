defmodule Day01 do
  @moduledoc """
  Advent of Code 2018, day 1.
  """

  @doc """
  part1 reads the data and keeps a running tally of the numbers, starting from zero.

  ## Examples

      iex> Day01.part1_v1("data/day01.txt")
      592

  """

  def part1_v1(file_name) do
    File.stream!(file_name)
    |> Enum.reduce(0, &add_line/2)
  end

  defp add_line(line, acc) do
    line
    |> String.trim()
    |> String.to_integer()
    |> Kernel.+(acc)
  end

  @doc """
  Pipes within pipes, to avoid the helper func. Plumbing nightmare?

  ## Examples

      iex> Day01.part1_v2("data/day01.txt")
      592

  """

  def part1_v2(file_name) do
    File.stream!(file_name)
    |> Enum.reduce(0, &(&1 |> String.trim() |> String.to_integer() |> Kernel.+(&2)))
  end

  @doc """
  Same code as v2, but formatted differently. Easier to follow than v2, but is this any better than v1?
  The anonymous func still looks noisy.

  ## Examples

      iex> Day01.part1_v3("data/day01.txt")
      592

  """

  def part1_v3(file_name) do
    File.stream!(file_name)
    |> Enum.reduce(
      0,
      &(&1
        |> String.trim()
        |> String.to_integer()
        |> Kernel.+(&2))
    )
  end

  @doc """
  Streams. Should be just as efficient as the other versions, because streams are lazy.
  In some ways, this may be the cleanest approach: Say exactly what you want to do.
   But is it a little obscure? Is everybody comfortable with streams vs. enums? Am I?

  ## Examples

      iex> Day01.part1_v4("data/day01.txt")
      592

  """

  def part1_v4(file_name) do
    File.stream!(file_name)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.to_integer/1)
    |> Enum.sum()
  end
end
