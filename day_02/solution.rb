#!/usr/bin/env ruby

def part1(input)
  puts "Part 1\n======\n"
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
  puts "\nPart 2\n======\n"
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

puts part1(input)
puts part2(input)
