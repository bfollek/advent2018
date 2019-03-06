defmodule Day02 do
  @moduledoc """
  Advent of Code 2018, day 2.

  todo
    # {:more, list1, list2, nil}
  # {:done, _, _, result}
  Todo:
  Don't permute all the strings. Check a pair, stop ASAP.
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
    # char_groups is a list of lists of lists. Each element in char_groups
    # corresponds to a string in the file. The string has been transformed
    # into a list of lists. Each inner list is a list of one or more
    # identical chars that we can count.
    char_groups =
      File.stream!(file_name)
      # We can leave the newlines because they won't affect the results
      |> Enum.map(&group_chars/1)

    count_chars(char_groups, 2) * count_chars(char_groups, 3)
  end

  defp group_chars(s) do
    # From "aba" to ["a", "b", "a"]
    String.graphemes(s)
    # From ["a", "b", "a"] to %{"a" => ["a", "a"], "b" => ["b"]}
    |> Enum.group_by(& &1)
    # From %{"a" => ["a", "a"], "b" => ["b"]} to [["a", "a"], ["b"]]
    |> Map.values()
  end

  defp count_chars(char_groups, len) do
    char_groups
    |> Enum.filter(&Enum.any?(&1, fn letter_list -> length(letter_list) == len end))
    |> length
  end

  @doc """
  Read a file of strings;
  Find the two strings that differ by one char in the same position;
  Return the other chars they have in common.

  Conditions:
  Preserve the original order of the common chars.

  ## Examples

      iex> Day02.part2_for("data/day02.txt")
      "fvstwblgqkhpuixdrnevmaycd"

  """
  def part2_for(file_name) do
    ss =
      File.stream!(file_name)
      |> Stream.map(&String.trim/1)

    # From ["abc", "def", "ghi"] to [["abc", "def"], ["abc", "ghi"], ["def", "ghi"]]
    # The less-than filter makes sure we don't get dups by comparing both ["a", "b"] and ["b", "a"]
    # Then filter to find the pair that differs by 1 char.
    # Then extract the common chars.
    [h | _] = for(s1 <- ss, s2 <- ss, s1 < s2, differ_by_1?(s1, s2), do: common_chars(s1, s2))

    h
  end

  def differ_by_1?(s1, s2), do: String.length(s1) == String.length(common_chars(s1, s2)) + 1

  def common_chars(s1, s2) when is_binary(s1) and is_binary(s2),
    do: _common_chars(String.graphemes(s1), String.graphemes(s2)) |> Enum.join()

  def _common_chars([], []), do: []
  def _common_chars([h1 | t1], [h2 | t2]) when h1 == h2, do: [h1 | _common_chars(t1, t2)]
  def _common_chars([_ | t1], [_ | t2]), do: _common_chars(t1, t2)
end
