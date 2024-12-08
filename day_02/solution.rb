#!/usr/bin/env ruby

require 'benchmark'

def part1(input)
  input.count do |report|
    sign_method = report[1] - report[0] < 0 ? :negative? : :positive?
    report.each_with_index.all? do |level, i|
      next true if i == 0

      diff = level - report[i - 1]
      diff.send(sign_method) && diff.abs <= 3
    end
  end
end

def part2(input)
  input.count do |report|
    variations = report.each_index.map { |i| report.dup.tap { |rep_dup| rep_dup.delete_at(i) } }
    ([report] + variations).any? do |r|
      sign_method = r[1] - r[0] < 0 ? :negative? : :positive?
      r.each_with_index.all? do |level, i|
        next true if i == 0

        diff = level - r[i - 1]
        diff.send(sign_method) && diff.abs <= 3
      end
    end
  end
end

input = File.readlines('input.txt').map { |line| line.split.map(&:to_i) }

p1_result = nil
p1_time = Benchmark.realtime { p1_result = part1(input) } * 1000
puts("Part 1 in #{p1_time.round(3)} ms\n  #{p1_result}\n\n")

p2_result = nil
p2_time = Benchmark.realtime { p2_result = part2(input) } * 1000
puts("Part 2 in #{p2_time.round(3)} ms\n  #{p2_result}\n\n")
