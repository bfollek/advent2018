# benchmark.exs
# mix run benchmark.exs

Benchee.run(
  %{
    "part2 for v1" => fn ->
      Day02.part2_for_v1("data/day02.txt")
    end,
    "part2 for v2" => fn ->
      Day02.part2_for_v2("data/day02.txt")
    end,
    "part2 fast" => fn ->
      Day02.part2_fast("data/day02.txt")
    end
  },
  time: 10,
  memory_time: 2
)
