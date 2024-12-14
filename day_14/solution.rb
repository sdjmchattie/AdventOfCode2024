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
  100000.times do |i|
    plot = height.times.map { |_| ['.'] * width }

    robots.each do |r|
      x = (r[0] + r[2] * i) % width
      y = (r[1] + r[3] * i) % height
      plot[y][x] = '#'
    end

    break i if plot.any? { |line| line.join.include? '###########' }
  end
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
