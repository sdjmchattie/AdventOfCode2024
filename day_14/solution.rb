#!/usr/bin/env ruby

require 'benchmark'

def part1(robots, width, height)
  positions = robots.map do |r|
    x = (r[0] + r[2] * 100) % width
    y = (r[1] + r[3] * 100) % height
    [x, y]
  end

  [
    positions.count { |p| p[0] < width / 2 && p[1] < height / 2 },
    positions.count { |p| p[0] < width / 2 && p[1] > height / 2 },
    positions.count { |p| p[0] > width / 2 && p[1] < height / 2 },
    positions.count { |p| p[0] > width / 2 && p[1] > height / 2 }
  ].reduce(&:*)
end

def part2(robots, width, height)
  File.open('tree_hunt.txt', 'w') do |f|
    10000.times do |i|
      next unless (i - 8) % 101 == 0 || (i - 78) % 103 == 0

      plot = height.times.map { |_| ['.'] * width }
      robots.each do |r|
        x = (r[0] + r[2] * i) % width
        y = (r[1] + r[3] * i) % height
        plot[y][x] = '#'
      end

      f.puts "After #{i} seconds:"
      plot.each do |row|
        f.puts row.join
      end
      f.puts
      f.puts
    end
  end

  "Check the file tree_hunt.txt!"
end

input = File.readlines('input.txt')
robots = input.map { |line| line.scan(/-?\d+/).map(&:to_i) }
width = 101
height = 103

p1_result = nil
p1_time = Benchmark.realtime { p1_result = part1(robots, width, height) } * 1000
puts("Part 1 in #{p1_time.round(3)} ms\n  #{p1_result}\n\n")

p2_result = nil
p2_time = Benchmark.realtime { p2_result = part2(robots, width, height) } * 1000
puts("Part 2 in #{p2_time.round(3)} ms\n  #{p2_result}\n\n")
