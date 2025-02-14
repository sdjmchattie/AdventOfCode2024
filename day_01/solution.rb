#!/usr/bin/env ruby

require 'benchmark'

def part1(input)
  left, right = input.transpose
  left.sort!
  right.sort!

  left.zip(right).map { |l, r| (l - r).abs }.sum
end

def part2(input)
  left, right = input.transpose

  right_counts = right.group_by(&:itself).transform_values(&:count)
  left.map { |l| l * right_counts.fetch(l, 0) }.sum
end

input = File.readlines('input.txt').map { |line| line.split.map(&:to_i) }

p1_result = nil
p1_time = Benchmark.realtime { p1_result = part1(input) } * 1000
puts("Part 1 in #{p1_time.round(3)} ms\n  #{p1_result}\n\n")

p2_result = nil
p2_time = Benchmark.realtime { p2_result = part2(input) } * 1000
puts("Part 2 in #{p2_time.round(3)} ms\n  #{p2_result}\n\n")
