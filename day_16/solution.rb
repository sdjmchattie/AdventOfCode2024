#!/usr/bin/env ruby

require 'benchmark'
require_relative '../lib/grid/grid_2d.rb'

def valid_dirs(loc, dir, map)
  {
    loc.move(dir) => [dir, 1],
    loc.move(Grid::turn_left(dir)) => [Grid::turn_left(dir), 1001],
    loc.move(Grid::turn_right(dir)) => [Grid::turn_right(dir), 1001]
  }.reject { |new_loc, _| map[new_loc] == '#' }.values
end

def lowest_scores_to_end(map)
  start = map.find('S').first
  goal = map.find('E').first
  unvisited = Set.new((map.find('.') + [goal]).product(Grid::UDLR))
  data = Hash.new { |h, k| h[k] = { score: 10**9, path: Set.new } }
  valid_dirs(start, :e, map).each { |dir, cost| data[[start, dir]] = { score: cost, path: Set.new([start]) } }

  loc, dir = data.keys.select { |l, _| l == start }.min_by { |k| data[k][:score] }
  until loc == goal
    new_loc = loc.move(dir)
    valid_dirs(new_loc, dir, map).each do |new_dir, cost|
      if data[[new_loc, new_dir]][:score] == data[[loc, dir]][:score] + cost
        data[[new_loc, new_dir]][:path] += data[[loc, dir]][:path].dup.add(new_loc)
      elsif data[[new_loc, new_dir]][:score] > data[[loc, dir]][:score] + cost
        data[[new_loc, new_dir]][:score] = data[[loc, dir]][:score] + cost
        data[[new_loc, new_dir]][:path] = data[[loc, dir]][:path].dup.add(new_loc)
      end
    end

    return { score: data[[loc, dir]][:score], path: data[[loc, dir]][:path] + [goal] } if new_loc == goal

    unvisited.delete([loc, dir])

    loc, dir = data.keys.select { |k| unvisited.include?(k) }.min_by { |k| data[k][:score] }
  end
end

def part1(result)
  result[:score]
end

def part2(result)
  result[:path].count
end

input = File.readlines('example.txt')
result = lowest_scores_to_end(Grid::Grid2D.new(input))

p1_result = nil
p1_time = Benchmark.realtime { p1_result = part1(result) } * 1000
puts("Part 1 in #{p1_time.round(3)} ms\n  #{p1_result}\n\n")

p2_result = nil
p2_time = Benchmark.realtime { p2_result = part2(result) } * 1000
puts("Part 2 in #{p2_time.round(3)} ms\n  #{p2_result}\n\n")
