#!/usr/bin/env ruby

require 'benchmark'

def get_mul(input)
  input.scan(/mul\((\d+),(\d+)\)/).reduce(0) { |acc, mul| acc + mul.map(&:to_i).reduce(&:*) }
end

def part1(input)
  get_mul(input)
end

def part2(input)
  disabled = input.scan(/don't\(\).*?do\(\)/).reduce("", &:+)
  get_mul(input) - get_mul(disabled)
end

input = File.readlines('input.txt').reduce("", &:+).gsub("\n", '')

p1_result = nil
p1_time = Benchmark.realtime { p1_result = part1(input) } * 1000
puts("Part 1 in #{p1_time.round(3)} ms\n  #{p1_result}\n\n")

p2_result = nil
p2_time = Benchmark.realtime { p2_result = part2(input) } * 1000
puts("Part 2 in #{p2_time.round(3)} ms\n  #{p2_result}\n\n")
