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
  Remove the differing char and return the common chars.

  Conditions:
  Preserve the original order of the comman chars.

  ## Examples

      iex> Day02.part2("data/day02.txt")
      "fvstwblgqkhpuixdrnevmaycd"

  """
  def part2(file_name) do
    ss =
      File.stream!(file_name)
      |> Stream.map(&String.trim/1)

    # iex(34)> for e1 <- l1, e2 <- l2, do: [e1, e2]
    # [[1, 4], [1, 5], [1, 6], [2, 4], [2, 5], [2, 6], [3, 4], [3, 5], [3, 6]]

    # Permute ss with itself.
    # From ["abc", "def", "ghi"] to [["abc", "def"], ["abc", "ghi"], ["def", "ghi"]]
    pairs = for e1 <- ss, e2 <- ss, e1 != e2, do: [e1, e2]
    IO.puts(inspect(pairs))

    "?"
    # iex(29)> Enum.zip([1,2,3], [1,2,3])
    # [{1, 1}, {2, 2}, {3, 3}]
    # iex(28)> String.myers_difference("abcd", "abzd")
    # [eq: "ab", del: "c", ins: "z", eq: "d"]
  end
end
