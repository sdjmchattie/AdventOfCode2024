#!/usr/bin/env ruby

require 'benchmark'

def simulate_stones(stones, blinks)
  hash = Hash.new(0)
  stones.each { |stone| hash[stone] += 1 }

  blinks.times do
    new_hash = Hash.new(0)
    hash.each do |stone, num|
      if stone == '0'
        new_hash['1'] += num
        next
      end

      len = stone.length
      if len % 2 == 0
        new_hash[stone[0...len / 2]] += num
        new_hash[stone[len / 2..-1].to_i.to_s] += num
        next
      end

      new_hash[(stone.to_i * 2024).to_s] += num
    end

    hash = new_hash
  end

  hash.values.sum
end

def part1(input)
  stones = input.split(' ')
  simulate_stones(stones, 25)
end

def part2(input)
  stones = input.split(' ')
  simulate_stones(stones, 75)
end

input = File.readlines('input.txt')[0].chomp

p1_result = nil
p1_time = Benchmark.realtime { p1_result = part1(input) } * 1000
puts("Part 1 in #{p1_time.round(3)} ms\n  #{p1_result}\n\n")

p2_result = nil
p2_time = Benchmark.realtime { p2_result = part2(input) } * 1000
puts("Part 2 in #{p2_time.round(3)} ms\n  #{p2_result}\n\n")
