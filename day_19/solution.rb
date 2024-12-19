#!/usr/bin/env ruby

require 'benchmark'

CACHE = {}

def ways_to_create_pattern(pattern, towels)
  return 1 if pattern.empty?
  return CACHE[pattern] if CACHE.has_key?(pattern)

  ways = towels.select { |towel| pattern.start_with?(towel) }.reduce(0) do |acc, towel|
    acc + ways_to_create_pattern(pattern[towel.length..], towels)
  end

  CACHE[pattern] = ways
end

def part1(towels, patterns)
  patterns.count { |pattern| ways_to_create_pattern(pattern, towels) > 0 }
end

def part2(towels, patterns)
  patterns.sum { |pattern| ways_to_create_pattern(pattern, towels) }
end

input = File.readlines('input.txt')
towels = input[0].chomp.split(', ')
patterns = input[2..].map(&:chomp)

p1_result = nil
p1_time = Benchmark.realtime { p1_result = part1(towels, patterns) } * 1000
puts("Part 1 in #{p1_time.round(3)} ms\n  #{p1_result}\n\n")

p2_result = nil
p2_time = Benchmark.realtime { p2_result = part2(towels, patterns) } * 1000
puts("Part 2 in #{p2_time.round(3)} ms\n  #{p2_result}\n\n")
