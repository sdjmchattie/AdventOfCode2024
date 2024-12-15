#!/usr/bin/env ruby

require 'benchmark'
require_relative '../lib/grid/grid_2d.rb'

MOVES = { '^' => :n, '>' => :e, 'v' => :s, '<' => :w }

def plan_moves(point, dir, map, moved = Set.new)
  return [] if moved.include?(point)

  moved << point
  to_point = point.move(dir)
  return [[point, to_point]] if map[to_point] == '#' || map[to_point] == '.'

  this_move = [[point, to_point]]
  case map[to_point]
  when 'O'
    this_move + plan_moves(to_point, dir, map, moved)
  when '['
    this_move + plan_moves(to_point, dir, map, moved) + plan_moves(to_point.move(:e), dir, map, moved)
  when ']'
    this_move + plan_moves(to_point, dir, map, moved) + plan_moves(to_point.move(:w), dir, map, moved)
  end
end

def sort_moves(planned_moves, dir)
  case dir
  when :n
    planned_moves.sort { |a, b| a.last.y - b.last.y }
  when :e
    planned_moves.sort { |a, b| b.last.x - a.last.x }
  when :s
    planned_moves.sort { |a, b| b.last.y - a.last.y }
  when :w
    planned_moves.sort { |a, b| a.last.x - b.last.x }
  end
end

def do_moves(planned_moves, map)
  moved = Set.new

  planned_moves.each do |move|
    next if moved.include?(move.first)

    moved << move.first
    map[move.last] = map[move.first]
    map[move.first] = '.'
  end
end

def run_simulation(map, moves)
  robot = map.find('@').first

  moves.each do |dir|
    planned_moves = plan_moves(robot, dir, map)
    next if planned_moves.map(&:last).any? { |point| map[point] == '#' }

    sorted_moves = sort_moves(planned_moves, dir)
    do_moves(sorted_moves, map)
    map[robot] = '.'
    robot = robot.move(dir)
  end
end

def part1(map, moves)
  run_simulation(map, moves)
  map.find('O').sum { |point| point.x + 100 * point.y }
end

def part2(map, moves)
  run_simulation(map, moves)
  map.find('[').sum { |point| point.x + 100 * point.y }
end

input = File.readlines('input.txt')
map = Grid::Grid2D.new(input.take_while { |line| line != "\n" })
moves = input[map.height + 1..].map(&:chomp).join.chars.map { |c| MOVES[c] }

p1_result = nil
p1_time = Benchmark.realtime { p1_result = part1(map, moves) } * 1000
puts("Part 1 in #{p1_time.round(3)} ms\n  #{p1_result}\n\n")

# Recreate the map in double-width.
widenification = {
  '#' => '##',
  'O' => '[]',
  '@' => '@.',
  '.' => '..'
}
map_input = input.take_while { |line| line != "\n" }
wide_input = map_input.map { |line| line.chars.map { |c| widenification[c] }.join }
wide_map = Grid::Grid2D.new(wide_input)

p2_result = nil
p2_time = Benchmark.realtime { p2_result = part2(wide_map, moves) } * 1000
puts("Part 2 in #{p2_time.round(3)} ms\n  #{p2_result}\n\n")
