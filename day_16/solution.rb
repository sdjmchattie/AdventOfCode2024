#!/usr/bin/env ruby

require 'benchmark'
require_relative '../lib/grid/grid_2d.rb'

def lowest_score_to_end(map)
  start = map.find('S').first
  goal = map.find('E').first
  unvisited = Set.new(map.find('.') + [start, goal])
  scores = Hash.new { |h, k| h[k] = Hash.new(10**9) }
  scores[start] = { e: 0 }

  loc = start
  dir = :e
  until loc == goal
    score = scores[loc][dir]

    forward = loc.move(dir)
    scores[forward][dir] = [scores[forward][dir], score + 1].min unless map[forward] == '#'

    left_dir = Grid::turn_left(dir)
    left_loc = loc.move(left_dir)
    scores[left_loc][left_dir] = [scores[left_loc][left_dir], score + 1001].min unless map[left_loc] == '#'

    right_dir = Grid::turn_right(dir)
    right_loc = loc.move(right_dir)
    scores[right_loc][right_dir] = [scores[right_loc][right_dir], score + 1001].min unless map[right_loc] == '#'

    unvisited.delete(loc)

    loc = unvisited.min_by { |e| scores[e].values.min || 10**9 }
    dir = scores[loc].key(scores[loc].values.min)
  end

  scores[goal].values.min
end

def part1(map)
  lowest_score_to_end(map)
end

def part2(map)
end

input = File.readlines('input.txt')

p1_result = nil
p1_time = Benchmark.realtime { p1_result = part1(Grid::Grid2D.new(input)) } * 1000
puts("Part 1 in #{p1_time.round(3)} ms\n  #{p1_result}\n\n")

p2_result = nil
p2_time = Benchmark.realtime { p2_result = part2(Grid::Grid2D.new(input)) } * 1000
puts("Part 2 in #{p2_time.round(3)} ms\n  #{p2_result}\n\n")
