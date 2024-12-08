#!/usr/bin/env ruby

require 'benchmark'

class SparseArray
  def initialize(value_type, *value_args)
    @store = {}
    @value_type = value_type
    @value_args = value_args
  end

  def [](key)
    @store[key] ||= @value_type.new(*@value_args)
  end

  def []=(key, value)
    @store[key] = value
  end
end

def pages_valid(rules, print_job)
  print_job.each_with_index do |page, index|
    print_job[index + 1..].each do |sub_page|
      return false if rules[sub_page].include?(page)
    end
  end

  true
end

def fix_order(rules, print_job)
  print_job.map do |page|
    [page, rules[page].count { |dependents| print_job.include?(dependents) }]
  end.sort_by(&:last).map(&:first)
end

def part1(rules, print_jobs)
  print_jobs.select { |job|
    pages_valid(rules, job)
  }.sum { |job|
    job[(job.count - 1) / 2].to_i
  }
end

def part2(rules, print_jobs)
  print_jobs.reject { |job|
    pages_valid(rules, job)
  }.map { |job|
    fix_order(rules, job)
  }.sum { |job|
    job[(job.count - 1) / 2].to_i
  }
end

input = File.readlines('input.txt')
index = input.index("\n")
order = input.shift(index)
input.shift
print_jobs = input.map { |line| line.chomp.split(',') }

rules = SparseArray.new(Array)
order.each do |line|
  before, after = line.chomp.split('|')
  rules[before] << after
end

p1_result = nil
p1_time = Benchmark.realtime { p1_result = part1(rules, print_jobs) } * 1000
puts("Part 1 in #{p1_time.round(3)} ms\n  #{p1_result}\n\n")

p2_result = nil
p2_time = Benchmark.realtime { p2_result = part2(rules, print_jobs) } * 1000
puts("Part 2 in #{p2_time.round(3)} ms\n  #{p2_result}\n\n")
