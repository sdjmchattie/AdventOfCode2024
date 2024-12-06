#!/usr/bin/env ruby

require_relative '../lib/grid/grid_2d.rb'

def part1(input)
  puts "Part 1\n======\n"

  input.width.times.sum do |x|
    input.height.times.sum do |y|
      point = Grid::Point2D.new(x, y)
      next 0 unless input[point] == 'X'

      Grid::DIRECTIONS.keys.count do |direction|
        input.adjacent_values_in_direction(point, direction).join.start_with?('MAS')
      end
    end
  end
end

def part2(input)
  puts "\nPart 2\n======\n"

  input.width.times.sum do |x|
    input.height.times.count do |y|
      ne_word = input.adjacent_values_in_direction(Grid::Point2D.new(x, y), :ne, including_self: true).join
      next false unless ne_word.start_with?('MAS') || ne_word.start_with?('SAM')

      se_word = input.adjacent_values_in_direction(Grid::Point2D.new(x, y - 2), :se, including_self: true).join
      se_word.start_with?('MAS') || se_word.start_with?('SAM')
    end
  end
end

file_contents = File.readlines('input.txt')
input = Grid::Grid2D.new(file_contents)

puts part1(input)
puts part2(input)
