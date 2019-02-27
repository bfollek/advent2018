# benchmark.exs
# mix run benchmark.exs

Benchee.run(
  %{
    "helper" => fn ->
      Day01.part1_v1_helper("data/day01.txt")
    end,
    "pipes" => fn ->
      Day01.part1_v2_pipes("data/day01.txt")
    end,
    "pretty_pipes" => fn ->
      Day01.part1_v3_pretty_pipes("data/day01.txt")
    end,
    "streams" => fn ->
      Day01.part1_v4_streams("data/day01.txt")
    end,
    "enums" => fn ->
      Day01.part1_v5_enums("data/day01.txt")
    end,
    "for" => fn ->
      Day01.part1_v6_for("data/day01.txt")
    end
  },
  time: 10,
  memory_time: 2
)

Benchee.run(
  %{
    "helper big" => fn ->
      Day01.part1_v1_helper("data/day01_big.txt")
    end,
    "pipes big" => fn ->
      Day01.part1_v2_pipes("data/day01_big.txt")
    end,
    "pretty_pipes big" => fn ->
      Day01.part1_v3_pretty_pipes("data/day01_big.txt")
    end,
    "streams big" => fn ->
      Day01.part1_v4_streams("data/day01_big.txt")
    end,
    "enums big" => fn ->
      Day01.part1_v5_enums("data/day01_big.txt")
    end,
    "for big" => fn ->
      Day01.part1_v6_for("data/day01_big.txt")
    end
  },
  time: 10,
  memory_time: 2
)
