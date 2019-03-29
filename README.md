# advent2018ex

Advent of Code 2018 in elixir

I'm doing this to learn elixir.

### Day 1 - Complete

#### Part 1

Straightforward:
* Read a text file;
* Each line has an integer;
* Sum the integers.

The interesting bit here was the different ways to write the solution. I wrote several (day01/lib/day01.ex), and benchmarked them. (day01/benchmark.exs and day01/data/benchmarks.out). 

Conclusions:
* With a small file, the differences in performance (speed and memory) were trivial;
* Even with a large file (200K lines), the code with multiple Enum.map/1 calls wasn't that much worse than the other versions;
* The most readable version (IMO) uses a helper function. It performed as well as the more cryptic versions.

Possible Explanations:
* The high quality of the elixir compiler and the beam VM;
* I'm using a benchmarking tool I don't know to benchmark code I wrote in a language I don't know to solve a trivial problem. There may be tunnel-sized holes anywhere in my approach.

#### Part 2

For this part, you have to potentially loop through the list of numbers in the file more than once. I thought that Stream.cycle would make this easy. (I did this part in clojure a few months back, and cycle worked well.) But I ran into two possibly related problems:

* To use the stream elements, I had to materialize them with an Enum function;
* Stream.cycle got slower and slower as the stream size increased.

It's certainly possible I was using Stream.cycle incorrectly. I ended up repeatedly loading the numbers from file as needed, and that worked fine: I got the right answer, and it was fast.

### Day 2 - Complete

#### Part 2

I wrote several versions. The fastest were concurrent on my 8-core MacBook. See day02/data/benchmarks.out.

One surprise: Changing this

```
# For each pair of strings, spawn a process that diffs them.
for(s1 <- ss, s2 <- ss, s1 < s2, do: {s1, s2})
|> Enum.each(&spawn_link(fn -> send(me, diff_strings(elem(&1, 0), elem(&1, 1))) end))
```

to this

```
 # For each pair of strings, spawn a process that diffs them.
for(
  s1 <- ss,
  s2 <- ss,
  s1 < s2,
  do: spawn_link(fn -> send(me, diff_strings(s1, s2)) end)
)
```

turned the fastest version into a relatively slow one. That is, the version that takes an apparent extra step and spawns via an Enum.each call, rather than directly from the for loop, was much faster than the version that spawns from the for loop.

Conclusion:
* Using multiple processes can be easy and effective, but small differences in the code can have large performance impacts. Benchmark to be sure.

Possible Explanation:
* I guess moving the spawn_link call into the for loop means a slight delay between spawns while the for loop conses up the result list. This delay means the processes don't get started as quickly, and that slows everything down.

### Day 3 - Complete



