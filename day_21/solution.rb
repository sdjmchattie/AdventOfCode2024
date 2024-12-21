#!/usr/bin/env ruby

require 'benchmark'

NUM_PAD = [
  ['7', '8', '9'],
  ['4', '5', '6'],
  ['1', '2', '3'],
  [' ', '0', 'A']
].freeze

DIR_PAD = [
  [' ', '^', 'A'],
  ['<', 'v', '>']
].freeze

def moves_between(sx, sy, gx, gy, pad)
  optimal = 1000
  moves = []
  queue = [[sx, sy, '']]
  return ['A'] if sx == gx && sy == gy

  until queue.empty?
    x, y, m = queue.shift
    [[0, 1, 'v'], [0, -1,'^'], [1, 0, '>'], [-1, 0, '<']].each do |dx, dy, dm|
      nx = x + dx
      ny = y + dy
      next if nx < 0 || nx >= pad[0].length || ny < 0 || ny >= pad.length
      next if pad[ny][nx] == ' '

      nm = m + dm
      return moves if nm.length > optimal

      if nx == gx && ny == gy
        optimal = nm.length
        moves << nm + 'A'
      end

      queue << [nx, ny, nm]
    end
  end
end

def calculate_moves(pad)
  keys = pad.each_with_index.flat_map do |row, y|
    row.each_with_index.map do |key, x|
      [key, x, y]
    end
  end

  keys.map do |sk, sx, sy|
    next if sk == ' '

    [
      sk,
      keys.map do |gk, gx, gy|
        next if gk == ' '

        [
          gk,
          moves_between(sx, sy, gx, gy, pad)
        ]
      end.compact.to_h
    ]
  end.compact.to_h
end

NUMPAD_MOVES = calculate_moves(NUM_PAD)
DIRPAD_MOVES = calculate_moves(DIR_PAD)

CACHE = {}

def compute_length(seq, depth = 1)
  return CACHE[[seq, depth]] unless CACHE[[seq, depth]].nil?

  if depth == 1
    CACHE[[seq, depth]] = seq.each_with_index.sum do |to, i|
      from = seq[i - 1]
      DIRPAD_MOVES[from][to][0].length
    end

    return CACHE[[seq, depth]]
  end

  CACHE[[seq, depth]] = seq.each_with_index.sum do |to, i|
    from = seq[i - 1]
    DIRPAD_MOVES[from][to].map { |subseq| compute_length(subseq.split(''), depth - 1) }.min
  end
end

def part1(dir_seqs)
  dir_seqs.sum do |val, sub_seqs|
    val * sub_seqs.map { |seq| compute_length(seq.split(''), 2) }.min
  end
end

def part2(dir_seqs)
  dir_seqs.sum do |val, sub_seqs|
    val * sub_seqs.map { |seq| compute_length(seq.split(''), 25) }.min
  end
end

input = File.readlines('input.txt')

dir_seqs = input.map do |line|
  num_seq = line.chomp.split('')
  dir_seqs = num_seq.each_with_index.map do |to, i|
    from = num_seq[i - 1]
    NUMPAD_MOVES[from][to]
  end.reduce(['']) do |acc, move|
    acc.product(move).map(&:join)
  end
  min_seq = dir_seqs.map(&:length).min
  [line[..-1].to_i, dir_seqs.select { |nseq| nseq.length == min_seq }]
end

p1_result = nil
p1_time = Benchmark.realtime { p1_result = part1(dir_seqs) } * 1000
puts("Part 1 in #{p1_time.round(3)} ms\n  #{p1_result}\n\n")

p2_result = nil
p2_time = Benchmark.realtime { p2_result = part2(dir_seqs) } * 1000
puts("Part 2 in #{p2_time.round(3)} ms\n  #{p2_result}\n\n")
