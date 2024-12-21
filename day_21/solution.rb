#!/usr/bin/env ruby

require 'benchmark'

# Numeric Keypad:
# +---+---+---+
# | 7 | 8 | 9 |
# +---+---+---+
# | 4 | 5 | 6 |
# +---+---+---+
# | 1 | 2 | 3 |
# +---+---+---+
#     | 0 | A |
#     +---+---+

NUMERIC_LAYOUT = {
  '7' => [0, 0],
  '8' => [1, 0],
  '9' => [2, 0],
  '4' => [0, 1],
  '5' => [1, 1],
  '6' => [2, 1],
  '1' => [0, 2],
  '2' => [1, 2],
  '3' => [2, 2],
  ' ' => [0, 3],
  '0' => [1, 3],
  'A' => [2, 3]
}.freeze

# Directional Keypad:
#     +---+---+
#     | ^ | A |
# +---+---+---+
# | < | v | > |
# +---+---+---+

DIRECTIONAL_LAYOUT = {
  ' ' => [0, 0],
  '^' => [1, 0],
  'A' => [2, 0],
  '<' => [0, 1],
  'v' => [1, 1],
  '>' => [2, 1]
}.freeze

def move_col(from, to)
  { -2 => '<<', -1 => '<', 0 => '', 1 => '>', 2 => '>>' }[to[0] - from[0]]
end

def move_row(from, to)
  { -3 => '^^^', -2 => '^^', -1 => '^', 0 => '', 1 => 'v', 2 => 'vv', 3 => 'vvv' }[to[1] - from[1]]
end

def keypad_path(from, to, layout)
  from_coord = layout[from]
  to_coord = layout[to]
  blank = layout[' ']

  row_first = from_coord[1] == blank[1] && to_coord[0] == blank[0]
  row_first ?
    move_row(from_coord, to_coord) + move_col(from_coord, to_coord) :
    move_col(from_coord, to_coord) + move_row(from_coord, to_coord)
end

def part1(input)
  input.sum do |line|
    # Numeric pad
    num_seq = line.chomp.split('')
    dirs = num_seq.each_with_index.map do |to, i|
      from = num_seq[i - 1]
      keypad_path(from, to, NUMERIC_LAYOUT) + 'A'
    end.join.split('')

    # Directional pads
    2.times do
      dirs = dirs.each_with_index.map do |to, i|
        from = dirs[i - 1]
        keypad_path(from, to, DIRECTIONAL_LAYOUT) + 'A'
      end.join.split('')
    end

    line[..-1].to_i * dirs.count
  end
end

def part2(input)
end

input = File.readlines('input.txt')

p1_result = nil
p1_time = Benchmark.realtime { p1_result = part1(input) } * 1000
puts("Part 1 in #{p1_time.round(3)} ms\n  #{p1_result}\n\n")

p2_result = nil
p2_time = Benchmark.realtime { p2_result = part2(input) } * 1000
puts("Part 2 in #{p2_time.round(3)} ms\n  #{p2_result}\n\n")
