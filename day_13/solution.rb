#!/usr/bin/env ruby

require 'benchmark'

def part1(claws)
  claws.sum do |claw|
    wins = []
    (0..100).each do |a|
      (0..100).each do |b|
        x = a * claw[0] + b * claw[2]
        y = a * claw[1] + b * claw[3]
        wins << a * 3 + b if x == claw[4] && y == claw[5]
      end
    end
    wins.min || 0
  end
end

def part2(claws)
  claws.sum do |claw|
    claw[4] += 10000000000000
    claw[5] += 10000000000000

    best = [1, 0]
    (0..100).each do |a|
      (0..100).each do |b|
        x = a * claw[0] + b * claw[2]
        y = a * claw[1] + b * claw[3]
        if x == y and x > 0
          tokens = a * 3 + b
          best = [tokens, x] if x / tokens > best[1] / best[0]
        end
      end
    end

    next 0 if best[1] == 0

    offset = 40000
    init_steps = (10000000000000 - offset) / best[1]
    init_cost = best[0] * init_steps
    init_dist = best[1] * init_steps

    extra_steps_a = [offset / claw[0], offset / claw[1]].max
    extra_steps_b = [offset / claw[2], offset / claw[3]].max

    wins = []
    (0..100 + extra_steps_a).each do |a|
      (0..100 + extra_steps_b).each do |b|
        x = a * claw[0] + b * claw[2]
        y = a * claw[1] + b * claw[3]
        wins << a * 3 + b + init_cost if x == claw[4] - init_dist && y == claw[5] - init_dist
      end
    end
    wins.min || 0
  end
end

input = File.readlines('input.txt')
claws = []
until input.empty?
  button_a = input.shift.scan(/X\+(\d+), Y\+(\d+)/).first.map(&:to_i)
  button_b = input.shift.scan(/X\+(\d+), Y\+(\d+)/).first.map(&:to_i)
  win = input.shift.scan(/X=(\d+), Y=(\d+)/).first.map(&:to_i)
  input.shift

  claws << [button_a[0], button_a[1], button_b[0], button_b[1], win[0], win[1]]
end

p1_result = nil
p1_time = Benchmark.realtime { p1_result = part1(claws) } * 1000
puts("Part 1 in #{p1_time.round(3)} ms\n  #{p1_result}\n\n")

p2_result = nil
p2_time = Benchmark.realtime { p2_result = part2(claws) } * 1000
puts("Part 2 in #{p2_time.round(3)} ms\n  #{p2_result}\n\n")
