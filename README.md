# Advent2018

Advent of Code 2018 in elixir

I'm doing this to learn elixir.

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
* The high quality of the elixir compiler and the beam VM;
* I'm using a benchmarking tool I don't know to benchmark code I wrote in a language I don't know to solve a trivial problem. There may be tunnel-sized holes anywhere in my approach.

#### Part 2

For this part, you have to potentially loop through the list of numbers in the file more than once. I thought that Stream.cycle would make this easy. (I did this part in clojure a few months back, and cycle worked well.) But I ran into two possibly related problems:

* To use the stream elements, I had to materialize them with an Enum function;
* Stream.cycle got slower and slower as the stream size increased.

It's certainly possible I was using Stream.cycle incorrectly. I ended up repeatedly loading the numbers from file as needed, and that worked fine: I got the right answer, and it was fast.

### Day 2

#### Part 2

Spoiler: The fastest version was concurrent. But there was a wrinkle that surprised me.

The difference between my first versions, part2_for_v1 and part2_for_v2, is that part2_for_v2 minimizes calls to common_char(). It's about 60ms faster than part2_for_v1 (benchmark output in day02/data/benchmarks.out).

But both versions use a list comprehension (for form) to build the pairs of strings. I think the code is clean, but it has a performance drawback: We build **all** the pairs of strings to look for the pair we want. It's more efficient to build a pair, test it, and keep going only if we haven't found the pair we want. 

elixir's for form isn't lazy, and I couldn't find a way to short-circuit it the way take() does in clojure. So I wrote a version that doesn't use the for form, and stops as soon as it finds the right strings. It's called part2_fast, and it's significantly faster than the other versions.

Then I wrote another version, part2_fast_agent, that stores the list of strings in an Agent rather than passing it around as a param. This slightly stateful solution seems a little cleaner than, and just as fast as, part2_fast without the agent.

Then I wrote a concurrent version, spawning a separate process to diff each pair of strings. My first version, part2_conc, was significantly faster than any other version on my 8-core MacBook. 

Enum.each doesn't have to concat the results...


