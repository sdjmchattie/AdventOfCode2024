#!/usr/bin/env ruby

require 'benchmark'

class Computer
  attr_reader :output
  attr_writer :break_if_output_does_not_match_program

  def initialize(program, register_a, register_b, register_c)
    @program = program
    @initial_a = register_a
    @initial_b = register_b
    @initial_c = register_c
    @break_if_output_does_not_match_program = false
    reset
  end

  def reset
    @registers = {
      a: @initial_a,
      b: @initial_b,
      c: @initial_c
    }
    @output = []
    @pointer = 0
  end

  def set_register(register, value)
    @registers[register] = value
  end

  OPERATIONS = %i[adv bxl bst jnz bxc out bdv cdv].freeze

  def run
    while @pointer < @program.length
      break if send(OPERATIONS[@program[@pointer]]) == :abort
    end
  end

  def operand(combo: false)
    literal = @program[@pointer + 1]
    return literal unless combo && literal > 3
    return @registers[:a] if literal == 4
    return @registers[:b] if literal == 5
    return @registers[:c] if literal == 6

    raise 'Invalid operand'
  end

  def adv
    @registers[:a] = @registers[:a] >> operand(combo: true)
    @pointer += 2
  end

  def bdv
    @registers[:b] = @registers[:a] >> operand(combo: true)
    @pointer += 2
  end

  def cdv
    @registers[:c] = @registers[:a] >> operand(combo: true)
    @pointer += 2
  end

  def bst
    @registers[:b] = (operand(combo: true) & 7)
    @pointer += 2
  end

  def bxl
    @registers[:b] = @registers[:b] ^ operand
    @pointer += 2
  end

  def bxc
    @registers[:b] = @registers[:b] ^ @registers[:c]
    @pointer += 2
  end

  def jnz
    @pointer = @registers[:a] == 0 ? @pointer + 2 : operand
  end

  def out
    @output << (operand(combo: true) & 7)
    @pointer += 2
    return :abort if @break_if_output_does_not_match_program && @output[-1] != @program[@output.length - 1]
  end
end

def part1(input)
  program = input[4].scan(/\d+/).map(&:to_i)
  register_a = input[0].scan(/\d+/).first.to_i
  register_b = input[1].scan(/\d+/).first.to_i
  register_c = input[2].scan(/\d+/).first.to_i

  computer = Computer.new(program, register_a, register_b, register_c)
  computer.run
  computer.output.join(',')
end

def part2(input)
  program = input[4].scan(/\d+/).map(&:to_i)
  register_a = input[0].scan(/\d+/).first.to_i
  register_b = input[1].scan(/\d+/).first.to_i
  register_c = input[2].scan(/\d+/).first.to_i

  computer = Computer.new(program, register_a, register_b, register_c)
  computer.break_if_output_does_not_match_program = true

  best = 0
  a_value = 0
  counter = 0
  while computer.output != program
    a_value = counter * 8**9 + 0o727236017

    computer.reset
    computer.set_register(:a, a_value)
    computer.run

    if computer.output == program[0..computer.output.length - 1] && computer.output.length >= best
      best = computer.output.length
      puts "#{a_value} (#{a_value.to_s(8)}) => #{best}"
    end

    counter += 1
  end

  a_value
end

input = File.readlines('input.txt')

p1_result = nil
p1_time = Benchmark.realtime { p1_result = part1(input) } * 1000
puts("Part 1 in #{p1_time.round(3)} ms\n  #{p1_result}\n\n")

p2_result = nil
p2_time = Benchmark.realtime { p2_result = part2(input) } * 1000
puts("Part 2 in #{p2_time.round(3)} ms\n  #{p2_result}\n\n")
