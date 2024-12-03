#!/usr/bin/env ruby

def get_mul(input)
  input.scan(/mul\((\d+),(\d+)\)/).reduce(0) { |acc, mul| acc + mul.map(&:to_i).reduce(&:*) }
end

def part1(input)
  puts "Part 1\n======\n"
  get_mul(input)
end

def part2(input)
  puts "\nPart 2\n======\n"
  disabled = input.scan(/don't\(\).*?do\(\)/).reduce("", &:+)
  get_mul(input) - get_mul(disabled)
end

input = File.readlines('input.txt').reduce("", &:+).gsub("\n", '')

puts part1(input)
puts part2(input)
