#!/usr/bin/env ruby

require 'benchmark'
require 'ruby-graphviz'

class Gate
  attr_accessor :output_wire
  attr_reader :source_gates

  def initialize(input_wires, output_wire)
    @input_wires = input_wires
    @output_wire = output_wire
  end

  def connect_to_sources(all_gates)
    self.input_gates = all_gates.select { |gate| self.input_wires.include?(gate.output_wire) }
  end

  def output_value
    @output_value ||= resolve_output
  end

  private

  attr_accessor :input_wires
  attr_accessor :input_gates

  def resolve_output
    raise NotImplementedError
  end
end

class Source < Gate
  def initialize(output_wire, output_value)
    super([], output_wire)
    @output_value = output_value
  end
end

class And < Gate
  def resolve_output
    self.input_gates.map(&:output_value).reduce(&:&)
  end
end

class Or < Gate
  def resolve_output
    self.input_gates.map(&:output_value).reduce(&:|)
  end
end

class Xor < Gate
  def resolve_output
    self.input_gates.map(&:output_value).reduce(&:^)
  end
end

def prepare_system(input)
  sources = input.select { |e| e.include?(':') }.map do |e|
    out_wire, out_value = e.match(/(...): ([01])/).captures
    Source.new(out_wire, out_value.to_i)
  end

  gates = input.select { |e| e.include?('->') }.map do |e|
    in_wire1, gate_type, in_wire2, out_wire = e.match(/(...) ([A-Z]+) (...) -> (...)/).captures
    Object.const_get(gate_type.capitalize).new([in_wire1, in_wire2], out_wire)
  end

  all_gates = sources + gates
  all_gates.each { |gate| gate.connect_to_sources(all_gates) }

  [sources, gates]
end

def get_z_value(gates)
  z_gates = gates.select { |gate| gate.output_wire.start_with?('z') }.sort_by(&:output_wire)
  z_gates.map(&:output_value).join.reverse.to_i(2)
end

def part1(input)
  _, gates = prepare_system(input)
  get_z_value(gates)
end

def part2(input)
  # Not sure how to do this with code, so let's plot it and check the operations by hand!
  g = GraphViz.new(:G, type: :digraph)
  nodes = {}

  input.select { |e| e.include?(':') }.map do |e|
    out_wire = e.match(/(...):/)[1]
    nodes[out_wire] = g.add_nodes("Source: #{out_wire}", shape: :oval)
  end

  input.select { |e| e.include?('->') }.map do |e|
    gate_type, out_wire = e.match(/... ([A-Z]+) ... -> (...)/).captures
    shape = {'AND' => :box, 'OR' => :diamond, 'XOR' => :trapezium}[gate_type]
    nodes[out_wire] = g.add_nodes("#{gate_type}: #{out_wire}", shape:)
  end

  input.select { |e| e.include?('->') }.map do |e|
    in_wire1, in_wire2, out_wire = e.match(/(...) [A-Z]+ (...) -> (...)/).captures
    g.add_edges(nodes[in_wire1], nodes[out_wire])
    g.add_edges(nodes[in_wire2], nodes[out_wire])
  end

  # Generate output image
  g.output(:png => "circuit.png")
end

# Identified swaps to keep the logic consistent across the circuit:
# ctg, rpb
# dmh, z31
# rpv, z11
# dvq, z38

def part2_test(input)
  sources, gates = prepare_system(input)

  x_sources = sources.select { |source| source.output_wire.start_with?('x') }.sort_by(&:output_wire)
  x_value = x_sources.map(&:output_value).join.reverse.to_i(2)

  y_sources = sources.select { |source| source.output_wire.start_with?('y') }.sort_by(&:output_wire)
  y_value = y_sources.map(&:output_value).join.reverse.to_i(2)

  z_gates = gates.select { |gate| gate.output_wire.start_with?('z') }.sort_by(&:output_wire)
  z_value = z_gates.map(&:output_value).join.reverse.to_i(2)

  "#{x_value} + #{y_value} = #{z_value} ?  #{x_value + y_value == z_value}"
end

input = File.readlines('input.txt')

p1_result = nil
p1_time = Benchmark.realtime { p1_result = part1(input) } * 1000
puts("Part 1 in #{p1_time.round(3)} ms\n  #{p1_result}\n\n")

p2_result = nil
p2_time = Benchmark.realtime { p2_result = part2(input) } * 1000
puts("Part 2 in #{p2_time.round(3)} ms\n  #{p2_result}\n\n")

puts part2_test(input)
puts ['ctg', 'rpb', 'dmh', 'z31', 'rpv', 'z11', 'dvq', 'z38'].sort.join(',')
