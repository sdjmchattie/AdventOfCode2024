#!/usr/bin/env ruby

require 'benchmark'

def part1(input)
  schemas = (0..input.count / 8).map do
    schema = input.shift(7)
    input.shift
    schema.map(&:chomp)
  end

  locks = schemas.select { |s| s[0][0] == '#' }.map do |s|
    s.map { |r| r.split('') }.transpose.map { |r| r.count { |e| e == '.' } }
  end
  keys = schemas.select { |s| s[0][0] == '.' }.map do |s|
    s.map { |r| r.split('') }.transpose.map { |r| r.count { |e| e == '#' } }
  end

  locks.sum { |l| keys.count { |k| k.each_with_index.all? { |kh, i| l[i] - kh >= 0 } } }
end

def part2(_)
  "Merry Christmas!"
end

input = File.readlines('input.txt')

p1_result = nil
p1_time = Benchmark.realtime { p1_result = part1(input) } * 1000
puts("Part 1 in #{p1_time.round(3)} ms\n  #{p1_result}\n\n")

p2_result = nil
p2_time = Benchmark.realtime { p2_result = part2(input) } * 1000
puts("Part 2 in #{p2_time.round(3)} ms\n  #{p2_result}\n\n")
