#!/usr/bin/env ruby

require 'benchmark'
require_relative '../lib/grid/grid_2d.rb'

UDLR = [:n, :e, :s, :w]

def find_dests(point, map)
  value = map[point].to_i
  return point if value == 9

  adj_points = map.adjacent_points(point, UDLR)
  adj_points.reduce(Set.new) do |dests, adj_point|
    adj_value = map[adj_point].to_i
    dests << find_dests(adj_point, map) if adj_value - value == 1
    dests.flatten
  end
end

def find_score(point, map)
  value = map[point].to_i
  return 1 if value == 9

  adj_points = map.adjacent_points(point, UDLR)
  adj_points.sum do |adj_point|
    adj_value = map[adj_point].to_i
    adj_value - value == 1 ? find_score(adj_point, map) : 0
  end
end

def part1(input)
  map = Grid::Grid2D.new(input)
  starts = map.find('0')
  scores = starts.map { |start| find_dests(start, map).count }
  scores.sum
end

def part2(input)
  map = Grid::Grid2D.new(input)
  starts = map.find('0')
  scores = starts.map { |start| find_score(start, map) }
  scores.sum
end

input = File.readlines('input.txt')

p1_result = nil
p1_time = Benchmark.realtime { p1_result = part1(input) } * 1000
puts("Part 1 in #{p1_time.round(3)} ms\n  #{p1_result}\n\n")

p2_result = nil
p2_time = Benchmark.realtime { p2_result = part2(input) } * 1000
puts("Part 2 in #{p2_time.round(3)} ms\n  #{p2_result}\n\n")
