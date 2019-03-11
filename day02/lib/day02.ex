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
  Return the other chars they have in common.

  Conditions:
  Preserve the original order of the common chars.

  Notes:
  * Builds all the string pairs in the for form.
  * Finds the right strings by filtering in the for form.
  * Calls common_chars/2 repeatedly for each string.

  ## Examples

      iex> Day02.part2_for_v1("data/day02.txt")
      "fvstwblgqkhpuixdrnevmaycd"

  """
  def part2_for_v1(file_name) do
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

  # True if first string is one char longer than the common chars.
  defp differ_by_1?(s1, s2), do: String.length(s1) == String.length(common_chars(s1, s2)) + 1

  defp common_chars(s1, s2) when is_binary(s1) and is_binary(s2),
    do: _common_chars(String.graphemes(s1), String.graphemes(s2)) |> Enum.join()

  defp _common_chars([], []), do: []
  defp _common_chars([h1 | t1], [h2 | t2]) when h1 == h2, do: [h1 | _common_chars(t1, t2)]
  defp _common_chars([_ | t1], [_ | t2]), do: _common_chars(t1, t2)

  @doc """

  Notes:
  * Builds all the string pairs in the for form.
  * Finds the right strings after the for form.
  * Calls common_chars/2 once for each string.

  ## Examples

      iex> Day02.part2_for_v2("data/day02.txt")
      "fvstwblgqkhpuixdrnevmaycd"

  """
  def part2_for_v2(file_name) do
    ss =
      File.stream!(file_name)
      |> Stream.map(&String.trim/1)

    # From ["abc", "def", "ghi"] to [["abc", "def"], ["abc", "ghi"], ["def", "ghi"]]
    # The less-than filter makes sure we don't get dups by comparing both ["a", "b"] and ["b", "a"]
    # The for form returns a list whose elements are tuples of {first string, common chars}
    {_, winner} =
      for(s1 <- ss, s2 <- ss, s1 < s2, do: {s1, common_chars(s1, s2)})
      |> Enum.find(fn t ->
        # Winner if first string is one char longer than the common chars.
        String.length(elem(t, 0)) == String.length(elem(t, 1)) + 1
      end)

    winner
  end

  @doc """

  Notes:
  * No for form
  * Doesn't pre-build all the string pairs
  * Stops as soon as it finds the right strings

  ## Examples

      iex> Day02.part2_fast("data/day02.txt")
      "fvstwblgqkhpuixdrnevmaycd"

  """
  def part2_fast(file_name) do
    ss =
      File.stream!(file_name)
      |> Enum.map(&String.trim/1)

    check_string(ss, ss, ss)
  end

  # If the second list is empty, we've checked the head of the first list
  # against all the other strings, without success. Move on to the next
  # value in the first list, and start with a full second list.
  defp check_string([_h | t], [], ss), do: check_string(t, ss, ss)

  # Check the head of the first list against each value in the second list.
  defp check_string([h1 | _t1] = lst1, [h2 | t2], ss) do
    cc = common_chars(h1, h2)

    # If the common chars between the head of the first list and the
    # head of the second list are just one char shorter than the head
    # of the first list, the two heads differ by just one char, and
    # we're done. Return the common chars.
    if String.length(h1) == String.length(cc) + 1 do
      cc
    else
      # Check the head of the first list against the next value in the second list.
      check_string(lst1, t2, ss)
    end
  end

  @doc """

  Notes:
  * Uses an agent to store the original list of strings
  * No for form
  * Doesn't pre-build all the string pairs
  * Stops as soon as it finds the right strings

  ## Examples

      iex> Day02.part2_fast_agent("data/day02.txt")
      "fvstwblgqkhpuixdrnevmaycd"

  """
  def part2_fast_agent(file_name) do
    ss =
      File.stream!(file_name)
      |> Enum.map(&String.trim/1)

    # Unless the Agent is already running, start it
    unless Process.whereis(SS), do: {:ok, _} = Agent.start_link(fn -> ss end, name: SS)
    check_string_fa(ss, ss)
  end

  # If the second list is empty, we've checked the head of the first list
  # against all the other strings, without success. Move on to the next
  # value in the first list, and start with a full second list.
  defp check_string_fa([_h | t], []) do
    ss = Agent.get(SS, & &1)
    check_string_fa(t, ss)
  end

  # Check the head of the first list against each value in the second list.
  defp check_string_fa([h1 | _t1] = lst1, [h2 | t2]) do
    cc = common_chars(h1, h2)

    # If the common chars between the head of the first list and the
    # head of the second list are just one char shorter than the head
    # of the first list, the two heads differ by just one char, and
    # we're done. Return the common chars.
    if String.length(h1) == String.length(cc) + 1 do
      cc
    else
      # Check the head of the first list against the next value in the second list.
      check_string_fa(lst1, t2)
    end
  end

  @doc """

  Notes:
  * Uses concurrency to search for the right strings
  * Stops as soon as it finds (via a message) the right strings
  * Spawns _after_ the for form

  ## Examples

      iex> Day02.part2_conc_v1("data/day02.txt")
      "fvstwblgqkhpuixdrnevmaycd"

  """
  def part2_conc_v1(file_name) do
    me = self()

    ss =
      File.stream!(file_name)
      |> Enum.map(&String.trim/1)

    # For each pair of strings, spawn a process that diffs them.
    for(s1 <- ss, s2 <- ss, s1 < s2, do: {s1, s2})
    |> Enum.each(&spawn_link(fn -> send(me, diff_strings(elem(&1, 0), elem(&1, 1))) end))

    message_loop()
  end

  defp message_loop do
    receive do
      {:found, cc} ->
        cc

      _ ->
        message_loop()
    end
  end

  # If s1 and s2 differ by just 1 char, return :found and the common chars.
  defp diff_strings(s1, s2) do
    cc = common_chars(s1, s2)

    if String.length(s1) == String.length(cc) + 1, do: {:found, cc}, else: :not_found
  end

  @doc """

  Notes:
  * Uses concurrency to search for the right strings
  * Stops as soon as it finds (via a message) the right strings
  * Uses the for form to spawn

  ## Examples

      iex> Day02.part2_conc_v2("data/day02.txt")
      "fvstwblgqkhpuixdrnevmaycd"

  """
  def part2_conc_v2(file_name) do
    me = self()

    ss =
      File.stream!(file_name)
      |> Enum.map(&String.trim/1)

    # For each pair of strings, spawn a process that diffs them.
    for(
      s1 <- ss,
      s2 <- ss,
      s1 < s2,
      do: spawn_link(fn -> send(me, diff_strings(s1, s2)) end)
    )

    message_loop()
  end

  @doc """

  Notes:
  * Uses concurrency to search for the right strings
  * Stops as soon as it finds (via a message) the right strings
  * Uses reduce_while

  ## Examples

      iex> Day02.part2_conc_v3("data/day02.txt")
      "fvstwblgqkhpuixdrnevmaycd"

  """
  def part2_conc_v3(file_name) do
    me = self()

    ss =
      File.stream!(file_name)
      |> Enum.map(&String.trim/1)

    # For each pair of strings, spawn a process that diffs them.
    Enum.each(ss, &spawn_link(fn -> send(me, diff_strings_v3(&1, ss)) end))

    message_loop()
  end

  defp diff_strings_v3(s, ss) do
    rv =
      Enum.reduce_while(ss, nil, fn nxt, _acc ->
        cc = common_chars(s, nxt)
        if String.length(s) == String.length(cc) + 1, do: {:halt, cc}, else: {:cont, nil}
      end)

    if rv, do: {:found, rv}, else: :not_found
  end
end
