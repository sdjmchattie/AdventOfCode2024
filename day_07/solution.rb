#!/usr/bin/env ruby

def valid_equation?(eq, op_count)
  result = eq[0]
  components = eq[1]
  ops_count = components.count - 1
  perms = op_count**(components.count - 1)

  perms.times do |perm|
    evaluated = perm.to_s(op_count).rjust(ops_count, '0').split('').each_with_index.reduce(components[0]) do |acc, e|
      next_val = components[e[1] + 1]
      case e[0]
      when '0'
        acc + next_val
      when '1'
        acc * next_val
      when '2'
        (acc.to_s + next_val.to_s).to_i
      end
    end

    return true if evaluated == result
  end

  return false
end

def part1(equations)
  puts "Part 1\n======\n"
  equations.reduce(0) { |acc, eq| acc + (valid_equation?(eq, 2) ? eq[0] : 0) }
end

def part2(equations)
  puts "\nPart 2\n======\n"
  equations.reduce(0) { |acc, eq| acc + (valid_equation?(eq, 3) ? eq[0] : 0) }
end

equations = File.readlines('input.txt').map { |line| line.chomp.split(':') }
equations.each do |eq|
  eq[0] = eq[0].to_i
  eq[1] = eq[1].chomp.split(' ').map(&:to_i)
end

puts part1(equations)
puts part2(equations)
