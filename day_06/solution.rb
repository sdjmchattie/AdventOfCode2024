#!/usr/bin/env ruby

require_relative '../lib/grid/grid_2d.rb'

def turn_right(dir)
  return Grid::DIRECTIONS[:e] if dir == Grid::DIRECTIONS[:n]
  return Grid::DIRECTIONS[:s] if dir == Grid::DIRECTIONS[:e]
  return Grid::DIRECTIONS[:w] if dir == Grid::DIRECTIONS[:s]

  return Grid::DIRECTIONS[:n]
end

def mark_route(grid)
  loc = grid.find('^').first
  dir = Grid::DIRECTIONS[:n]

  loop do
    grid[loc] = 'X'

    while grid[loc.move(dir)] == '#'
      dir = turn_right(dir)
    end

    loc = loc.move(dir)

    break unless ['.', 'X'].include?(grid[loc])
  end

  grid
end

def part1(file_contents)
  puts "Part 1\n======\n"
  marked = mark_route(Grid::Grid2D.new(file_contents))

  marked.count('X')
end

def part2(file_contents)
  puts "\nPart 2\n======\n"
  marked = mark_route(Grid::Grid2D.new(file_contents))

  grid = Grid::Grid2D.new(file_contents)
  start_loc = grid.find('^').first
  start_dir = Grid::DIRECTIONS[:n]

  marked.find('X').count do |blockage|
    next false if grid[blockage] != '.'

    loc = start_loc
    dir = start_dir
    turns = Hash.new { |h, k| h[k] = Set.new }

    loop do
      new_loc = loc.move(dir)
      break if turns[new_loc].include?(dir)

      while grid[new_loc] == '#' || new_loc == blockage
        turns[new_loc] << dir
        dir = turn_right(dir)
        new_loc = loc.move(dir)
      end

      loc = new_loc
      break unless grid.in_bounds?(loc)
    end

    grid.in_bounds?(loc)
  end
end

file_contents = File.readlines('input.txt')

puts part1(file_contents)
puts part2(file_contents)
