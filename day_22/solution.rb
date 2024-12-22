#!/usr/bin/env ruby

require 'benchmark'

def generate(secret)
  result = secret
  result = ((result << 6) ^ result) & 16777215
  result = ((result >> 5) ^ result) & 16777215
  ((result << 11) ^ result) & 16777215
end

def part1(input)
  input.sum { |i| 2000.times.reduce(i) { |acc, _| generate(acc) } }
end

def part2(input)
  change_map = input.map do |i|
    sequence = [i] + 2000.times.map { i = generate(i) }
    nanas = sequence.map { |v| v % 10 }

    map = {}
    last_four = []

    (1...nanas.count).each do |j|
      last_four.push(nanas[j] - nanas[j - 1])
      last_four.shift if last_four.count == 5
      map[last_four.dup] = map[last_four] || nanas[j] if last_four.count == 4
    end

    map
  end

  earnings = change_map.reduce({}) do |acc, m|
    m.each_key { |k| acc[k] = (acc[k] || 0) + m[k] }
    acc
  end

  earnings.values.max
end

input = File.readlines('input.txt').map(&:to_i)

p1_result = nil
p1_time = Benchmark.realtime { p1_result = part1(input) } * 1000
puts("Part 1 in #{p1_time.round(3)} ms\n  #{p1_result}\n\n")

p2_result = nil
p2_time = Benchmark.realtime { p2_result = part2(input) } * 1000
puts("Part 2 in #{p2_time.round(3)} ms\n  #{p2_result}\n\n")
