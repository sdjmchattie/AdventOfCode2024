#!/usr/bin/env ruby

require 'benchmark'

class Gate
  attr_reader :output_wire
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

def prepare_gates(input)
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
  all_gates
end

def part1(input)
  gates = prepare_gates(input)

  z_values = gates.select do |gate|
    gate.output_wire.match?('z\d\d')
  end.map do |gate|
    [gate.output_wire, gate.output_value]
  end.to_h

  binary_num = z_values.keys.sort.reverse.map { |z| z_values[z] }.join
  binary_num.to_i(2)
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
