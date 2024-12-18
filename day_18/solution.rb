#!/usr/bin/env ruby

require 'benchmark'
require_relative '../lib/grid/grid_2d.rb'

def min_path_length(grid, start, goal)
  unvisited = Set.new
  (0...grid.width).each do |x|
    (0...grid.height).each do |y|
      unvisited << [x, y]
    end
  end
  costs = Hash.new { |h, k| h[k] = 10**9 }
  costs[start] = 0

  current = start
  while current != goal
    grid.adjacent_coords(current, Grid::UDLR).each do |adjacent|
      next unless unvisited.include?(adjacent) && grid[adjacent[0], adjacent[1]] != '#'

      costs[adjacent] = [costs[adjacent], costs[current] + 1].min
    end

    unvisited.delete(current)
    current = unvisited.min_by { |point| costs[point] }
  end

  costs[goal]
end

def part1(memory, corruption_points)
  corruption_points[...1024].each { |x, y| memory[x, y] = '#' }
  min_path_length(memory, [0, 0], [memory.width - 1, memory.height - 1])
end

def part2(memory, corruption_points)
  lowest = 1024
  highest = corruption_points.length + 1
  while lowest + 1 != highest
    current = (lowest + highest) / 2
    memcpy = memory.empty_dup
    corruption_points[..current].each { |x, y| memcpy[x, y] = '#' }
    mpl = min_path_length(memcpy, [0, 0], [memcpy.width - 1, memcpy.height - 1])
    if mpl < 10**9
      lowest = current
    else
      highest = current
    end
  end

  corruption_points[highest].join(',')
end

input = File.readlines('input.txt')
points = input.map { |line| line.scan(/\d+/).map(&:to_i) }
width = points.map(&:first).max + 1
height = points.map(&:last).max + 1
memory = Grid::Grid2D.new(width:, height:)

p1_result = nil
p1_time = Benchmark.realtime { p1_result = part1(memory, points) } * 1000
puts("Part 1 in #{p1_time.round(3)} ms\n  #{p1_result}\n\n")

p2_result = nil
p2_time = Benchmark.realtime { p2_result = part2(memory, points) } * 1000
puts("Part 2 in #{p2_time.round(3)} ms\n  #{p2_result}\n\n")
