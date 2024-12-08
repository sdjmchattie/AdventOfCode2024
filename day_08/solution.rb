#!/usr/bin/env ruby

require 'benchmark'
require_relative '../lib/grid/grid_2d.rb'

def part1(map)
  antinodes = map.empty_dup
  map.all_chars.each do |freq|
    next if freq == '.'

    locs = map.find(freq)
    locs.each_with_index do |loc1, i|
      locs[i + 1..].each do |loc2|
        dx = loc2.x - loc1.x
        dy = loc2.y - loc1.y
        antinodes[Grid::Point2D.new(loc1.x - dx, loc1.y - dy)] = '#'
        antinodes[Grid::Point2D.new(loc2.x + dx, loc2.y + dy)] = '#'
      end
    end
  end

  antinodes.count('#')
end

def part2(map)
  antinodes = map.empty_dup
  map.all_chars.each do |freq|
    next if freq == '.'

    locs = map.find(freq)
    locs.each_with_index do |loc1, i|
      locs[i + 1..].each do |loc2|
        dx = loc2.x - loc1.x
        dy = loc2.y - loc1.y

        point = loc2
        antinodes[point] = '#' while map.in_bounds?(point = Grid::Point2D.new(point.x - dx, point.y - dy))

        point = loc1
        antinodes[point] = '#' while map.in_bounds?(point = Grid::Point2D.new(point.x + dx, point.y + dy))
      end
    end
  end

  antinodes.count('#')
end

contents = File.readlines('input.txt')
map = Grid::Grid2D.new(contents)

p1_result = nil
p2_result = nil

p1_time = Benchmark.realtime { p1_result = part1(map) } * 1000
p2_time = Benchmark.realtime { p2_result = part2(map) } * 1000

puts("Part 1 in #{p1_time.round(3)} ms\n  #{p1_result}\n\n")
puts("Part 2 in #{p2_time.round(3)} ms\n  #{p2_result}\n\n")
