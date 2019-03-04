defmodule Day02 do
  @moduledoc """
  Advent of Code 2018, day 2.
  """

  @doc """
  Read a file of strings;
  Check each string for duplicate and triplicate characters;
  Multiply the number of words that contain dups with the number of words that contain trips.

  Conditions:
  A dup must have exactly two chars, i.e. "abca" is a dup, "abcadaga" is not. Same for trips.
  If a word has multiple dups or multiple trips, count just one.
  If a word has both a dup and a trip, count both.

  ## Examples

      iex> Day02.part1("data/day02.txt")
      8715

  """
  def part1(file_name) do
    ss = File.stream!(file_name)
    has_2 = Enum.filter(ss, &check_string(&1, 2))
    has_3 = Enum.filter(ss, &check_string(&1, 3))
    length(has_2) * length(has_3)
  end

  defp check_string(s, i) do
    Enum.group_by(String.graphemes(s), & &1)
    # %{"a" => ["a", "a"], "b" => ["b", "b", "b"], "c" => ["c"], "d" => ["d", "d"]}
    |> Map.values()
    # [["a", "a"], ["b", "b", "b"], ["c"], ["d", "d"]]
    |> Enum.any?(&(length(&1) == i))
  end
end
