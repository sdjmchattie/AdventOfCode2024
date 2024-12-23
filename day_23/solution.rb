#!/usr/bin/env ruby

require 'benchmark'

def parse_network(input)
  input.reduce(Hash.new { |h, k| h[k] = Set.new }) do |acc, line|
    name_a, name_b = line.scan(/[a-z]+/)
    acc[name_a] << name_b
    acc[name_b] << name_a
    acc
  end
end

def part1(input)
  network = parse_network(input)
  t_comps = network.select { |comp| comp.start_with?('t') }
  t_networks = t_comps.keys.reduce(Set.new) do |acc, comp_t|
    network[comp_t].each do |comp_u|
      network[comp_u].each do |comp_v|
        acc << Set.new([comp_t, comp_u, comp_v]) if network[comp_v].include?(comp_t)
      end
    end

    acc
  end

  t_networks.count
end

CACHE = {}

def group(all_connects, in_group)
  return CACHE[in_group] if CACHE.has_key?(in_group)

  group_connects = Set.new(in_group.flat_map { |comp| all_connects[comp].to_a })
  group_connects.reject! { |comp| in_group.include?(comp) }
  candidates = group_connects.select { |comp| in_group.all? { |group_comp| all_connects[comp].include?(group_comp) } }

  groups = Set.new
  groups << in_group if candidates.empty?
  candidates.each { |candidate| groups.merge(group(all_connects, Set.new(in_group + [candidate]))) }

  CACHE[in_group] = groups
  groups
end

def part2(input)
  all_connects = parse_network(input)

  groups = Set.new()
  all_connects.keys.each do |comp|
    groups.merge(group(all_connects, Set.new([comp])))
  end

  largest_network = groups.max_by(&:count)
  largest_network.sort.join(',')
end

input = File.readlines('input.txt')

p1_result = nil
p1_time = Benchmark.realtime { p1_result = part1(input) } * 1000
puts("Part 1 in #{p1_time.round(3)} ms\n  #{p1_result}\n\n")

p2_result = nil
p2_time = Benchmark.realtime { p2_result = part2(input) } * 1000
puts("Part 2 in #{p2_time.round(3)} ms\n  #{p2_result}\n\n")
