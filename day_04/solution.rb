#!/usr/bin/env ruby

require_relative '../lib/grid/grid_2d.rb'

def part1(input)
  puts "Part 1\n======\n"

  words = input.width.times.flat_map do |x|
    input.height.times.flat_map do |y|
      DIRECTIONS.keys.map do |direction|
        input.adjacent_values_in_direction(x, y, direction, including_self: true).join
      end
    end
  end

  words.count { |word| word.start_with?('XMAS') }
end

def part2(input)
  puts "\nPart 2\n======\n"

  input.width.times.sum do |x|
    input.height.times.sum do |y|
      [:ne, :sw].count do |direction|
        next unless input.adjacent_values_in_direction(x, y, direction, including_self: true).join.start_with?('MAS')

        if direction == :ne
          next true if input.adjacent_values_in_direction(x, y - 2, :se, including_self: true).join.start_with?('MAS')
          next true if input.adjacent_values_in_direction(x + 2, y, :nw, including_self: true).join.start_with?('MAS')
        elsif direction == :sw
          next true if input.adjacent_values_in_direction(x, y + 2, :nw, including_self: true).join.start_with?('MAS')
          next true if input.adjacent_values_in_direction(x - 2, y, :se, including_self: true).join.start_with?('MAS')
        end

        false
      end
    end
  end
end

file_contents = File.readlines('input.txt')
input = Grid::Grid2D.new(file_contents)

puts part1(input)
puts part2(input)
