#!/usr/bin/env ruby

def part1(input)
  puts "Part 1\n======\n"
  left, right = input.transpose
  left.sort!
  right.sort!

  left.zip(right).map { |l, r| (l - r).abs }.sum
end

def part2(input)
  puts "\nPart 2\n======\n"
  left, right = input.transpose

  left.map { |l| l * right.count { |r| r == l } }.sum
end

input = File.readlines('input.txt').map { |line| line.split.map(&:to_i) }

puts part1(input)
puts part2(input)
