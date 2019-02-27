# Advent2018

Advent of Code 2018 in elixir

I'm doing this to learn elixir. I sometimes write multiple versions of a function, to play with different approaches.

### Day 1

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
* The high quality of the Elixir compiler and the beam VM;
* I'm using a benchmarking tool I don't knoow to benchmark code I wrote in a language I don't know to solve a trivial problem. There may be tunnel-sized holes in my approach.


