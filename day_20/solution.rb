#!/usr/bin/env ruby

require 'benchmark'
require_relative '../lib/grid/grid_2d.rb'

def find_route(grid)
  start = grid.find('S').first.to_coords
  goal = grid.find('E').first.to_coords
  queue = [[start, [start]]]
  visited = Set.new([start])

  until queue.empty?
    current, path = queue.shift
    grid.adjacent_coords(current, Grid::UDLR).each do |adjacent|
      next if visited.include?(adjacent)
      next if grid[*adjacent] == '#'

      new_path = path + [adjacent]
      visited << adjacent
      queue << [adjacent, new_path]

      return new_path if adjacent == goal
    end
  end
end

def count_shortcuts(route, cheat_length, time_saved)
  route[...-time_saved].each_with_index.sum do |start, si|
    route[si + time_saved..].each_with_index.count do |goal, gi|
      cheat_distance = (goal[0] - start[0]).abs + (goal[1] - start[1]).abs
      cheat_distance <= cheat_length && gi >= cheat_distance
    end
  end
end

def part1(map)
  route = find_route(map)
  count_shortcuts(route, 2, 100)
end

def part2(map)
  route = find_route(map)
  count_shortcuts(route, 20, 100)
end

input = File.readlines('input.txt')
map = Grid::Grid2D.new(input)

p1_result = nil
p1_time = Benchmark.realtime { p1_result = part1(map) } * 1000
puts("Part 1 in #{p1_time.round(3)} ms\n  #{p1_result}\n\n")

p2_result = nil
p2_time = Benchmark.realtime { p2_result = part2(map) } * 1000
puts("Part 2 in #{p2_time.round(3)} ms\n  #{p2_result}\n\n")
