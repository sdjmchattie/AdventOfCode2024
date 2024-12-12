#!/usr/bin/env ruby

require 'benchmark'
require_relative '../lib/grid/grid_2d.rb'

UDLR = [:n, :e, :s, :w]

def area_containing_point(point, map, seen = nil)
  seen ||= Set.new()
  seen << point
  label = map[point]
  map.adjacent_points(point, UDLR)
     .reject { |adj_point| map[adj_point] != label }
     .each do |adj_point|
       next if seen.include?(adj_point)

       seen.merge(area_containing_point(adj_point, map, seen))
     end

  seen
end

def perimeter(points, map)
  points.sum do |point|
    label = map[point]
    [
      map[Grid::Point2D.new(point.x - 1, point.y)],
      map[Grid::Point2D.new(point.x + 1, point.y)],
      map[Grid::Point2D.new(point.x, point.y + 1)],
      map[Grid::Point2D.new(point.x, point.y - 1)]
    ].count { |adj| adj != label }
  end
end

def part1(map)
  costs = 0
  seen = Set.new
  map.width.times do |x|
    map.height.times do |y|
      point = Grid::Point2D.new(x, y)
      next if seen.include?(point)

      area = area_containing_point(point, map)
      costs += perimeter(area, map) * area.count

      seen += area
    end
  end

  costs
end

def part2(input)
end

input = File.readlines('example.txt')
map = Grid::Grid2D.new(input)

p1_result = nil
p1_time = Benchmark.realtime { p1_result = part1(map) } * 1000
puts("Part 1 in #{p1_time.round(3)} ms\n  #{p1_result}\n\n")

p2_result = nil
p2_time = Benchmark.realtime { p2_result = part2(map) } * 1000
puts("Part 2 in #{p2_time.round(3)} ms\n  #{p2_result}\n\n")
