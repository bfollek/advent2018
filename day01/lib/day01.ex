defmodule Day01 do
  @moduledoc """
  Advent of Code 2018, day 1.
  """

  @doc """
  part1 reads the data and keeps a running sum of the numbers, starting from zero.

  ## Examples

      iex> Day01.part1_v1_helper("data/day01.txt")
      592

  """

  def part1_v1_helper(file_name) do
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

      iex> Day01.part1_v2_pipes("data/day01.txt")
      592

  """

  def part1_v2_pipes(file_name) do
    File.stream!(file_name)
    |> Enum.reduce(0, &(&1 |> String.trim() |> String.to_integer() |> Kernel.+(&2)))
  end

  @doc """
  Same code as v2, but formatted differently. Easier to follow than v2, but is this any better than v1?
  The anonymous func still looks noisy.

  ## Examples

      iex> Day01.part1_v3_pretty_pipes("data/day01.txt")
      592

  """

  def part1_v3_pretty_pipes(file_name) do
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

      iex> Day01.part1_v4_streams("data/day01.txt")
      592

  """

  def part1_v4_streams(file_name) do
    File.stream!(file_name)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.to_integer/1)
    |> Enum.sum()
  end

  @doc """
  Enums instead of streams. Should be noticeably slower.

  ## Examples

      iex> Day01.part1_v5_enums("data/day01.txt")
      592

  """

  def part1_v5_enums(file_name) do
    File.stream!(file_name)
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
  end

  @doc """
  for (list comprehension).

  ## Examples

      iex> Day01.part1_v6_for("data/day01.txt")
      592

  """

  def part1_v6_for(file_name) do
    Enum.sum(
      for line <- File.stream!(file_name), do: line |> String.trim() |> String.to_integer()
    )
  end

  @doc """
  part2 loops through the numbers till it sees a running sum for a second time.

  ## Examples

      iex> Day01.part2()
      241

  """

  def part2() do
    # part2_loop(num_list(), 0, %{0 => true})
    part2_loop_cycle(endless_nums(), 0, %{0 => true})
  end

  # We may have to pass through the numbers list multiple times before
  # we hit a duplicate sum. If we exhaust the list, start again.
  defp part2_loop([], sum, sums_seen), do: part2_loop(num_list(), sum, sums_seen)

  # When we repeat a sum, we're done.
  defp part2_loop([h | t], sum, sums_seen) do
    sum = h + sum

    if sums_seen[sum] do
      sum
    else
      part2_loop(t, sum, Map.put(sums_seen, sum, true))
    end
  end

  defp num_list() do
    File.stream!("data/day01.txt")
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.to_integer/1)
    |> Enum.to_list()
  end

  defp part2_loop_cycle(nums, sum, sums_seen) do
    nxt = Enum.at(nums, 0)
    sum = nxt + sum

    if sums_seen[sum] do
      sum
    else
      part2_loop_cycle(Stream.drop(nums, 1), sum, Map.put(sums_seen, sum, true))
    end
  end

  defp endless_nums() do
    # First, into a list
    e =
      File.stream!("data/day01.txt")
      |> Stream.map(&String.trim/1)
      |> Stream.map(&String.to_integer/1)
      |> Enum.to_list()

    # Next,cycle the list
    Stream.cycle(e)
  end
end
