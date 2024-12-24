#!/usr/bin/env ruby

require 'benchmark'

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

def swap_outputs(gate_a, gate_b)
  temp = gate_a.output_wire
  gate_a.output_wire = gate_b.output_wire
  gate_b.output_wire = temp

end

def test_system(x_sources, y_sources, gates)
  false
end

def part2(input)
  sources, gates = prepare_system(input)
  x_sources = sources.select { |gate| gate.output_wire.start_with?('x') }.sort_by(&:output_wire)
  y_sources = sources.select { |gate| gate.output_wire.start_with?('y') }.sort_by(&:output_wire)

  # Horrible loop incoming
  a1, a2, b1, b2, c1, c2, d1, d2 = (0..7).to_a
  gc = gates.count
  loop do
    puts "#{a1} <-> #{a2}, #{b1} <-> #{b2}, #{c1} <-> #{c2}, #{d1} <-> #{d2}"

    # Prepare the gates to swap
    swapped_gates = [
      gates[a1], gates[a2], gates[b1], gates[b2], gates[c1], gates[c2], gates[d1], gates[d2]
    ]

    # Do the swaps
    (0..3).each { |i| swap_outputs(swapped_gates[i * 2], swapped_gates[i * 2 + 1]) }
    gates.each { |gate| gate.connect_to_sources(sources + gates) }

    # Test the system
    return swapped_gates.map(&:output_wire).sort.join(',') if test_system(x_sources, y_sources, gates)

    # Undo the swaps (no need to connect the sources as it'll be done again on the next swap)
    (0..3).each { |i| swap_outputs(swapped_gates[i * 2], swapped_gates[i * 2 + 1]) }

    # Increment the swap indices (urgh!)
    loop do
      d2 += 1

      if d2 >= gc
        d1 += 1
        d2 = d1 + 1
      end

      if d1 >= gc
        c2 += 1
        d1 = d2 = c1 + 1
      end

      if c2 >= gc
        c1 += 1
        c2 = c1 + 1
      end

      if c1 >= gc
        b2 += 1
        c1 = c2 = b1 + 1
      end

      if b2 >= gc
        b1 += 1
        b2 = b1 + 1
      end

      if b1 >= gc
        a2 += 1
        b1 = b2 = a1 + 1
      end

      if a2 >= gc
        a1 += 1
        a2 = a1 + 1
      end

      if a1 >= gc
        return
      end

      break unless a1 == a2 || a2 == b1 || b1 == b2 || b2 == c1 || c1 == c2 || c2 == d1 || d1 == d2 ||
                   a1 >= gc || a2 >= gc || b1 >= gc || b2 >= gc || c1 >= gc || c2 >= gc || d1 >= gc || d2 >= gc
    end
  end
end

input = File.readlines('input.txt')

p1_result = nil
p1_time = Benchmark.realtime { p1_result = part1(input) } * 1000
puts("Part 1 in #{p1_time.round(3)} ms\n  #{p1_result}\n\n")

p2_result = nil
p2_time = Benchmark.realtime { p2_result = part2(input) } * 1000
puts("Part 2 in #{p2_time.round(3)} ms\n  #{p2_result}\n\n")
