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
    has_2 = count_chars(char_groups, 2)
    has_3 = count_chars(char_groups, 3)
    length(has_2) * length(has_3)
  end

  def group_by_chars(s) do
    # "abcabdbd" to ["a","b","c","a",etc.]
    String.graphemes(s)
    # ["a","b","c","a",etc.] to %{"a" => ["a", "a"], "b" => ["b", "b", "b"], "c" => ["c"], "d" => ["d", "d"]}
    |> Enum.group_by(& &1)
    # map to [["a", "a"], ["b", "b", "b"], ["c"], ["d", "d"]]
    |> Map.values()
  end

  def count_chars(char_groups, i) do
    Enum.filter(char_groups, &Enum.any?(&1, fn cg -> length(cg) == i end))
  end
end
