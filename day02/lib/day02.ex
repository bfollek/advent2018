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
    ss = File.stream!(file_name) |> Enum.map(&String.trim/1)
    char_groups = Enum.map(ss, &group_by_chars/1)
    has_2 = Enum.filter(char_groups, &Enum.any?(&1, fn cg -> length(cg) == 2 end))
    has_3 = Enum.filter(char_groups, &Enum.any?(&1, fn cg -> length(cg) == 3 end))
    length(has_2) * length(has_3)
  end

  def group_by_chars(s) do
    # %{"a" => ["a", "a"], "b" => ["b", "b", "b"], "c" => ["c"], "d" => ["d", "d"]}
    Enum.group_by(String.graphemes(s), & &1)
    # [["a", "a"], ["b", "b", "b"], ["c"], ["d", "d"]]
    |> Map.values()
  end
end
