#!/usr/bin/env ruby

require_relative '../lib/grid/grid_2d.rb'

def turn_right(dir)
  { n: :e, e: :s, s: :w, w: :n }[dir]
end

def mark_route(grid)
  loc = grid.find('^').first
  dir = :n

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
  start_dir = :n

  marked.find('X').reject { |x| x == start_loc }.count do |blockage|
    loc = start_loc
    dir = start_dir
    seen = Set.new

    loop do
      # Move to next blockage or edge of area
      loop do
        break if (n_loc = loc.move(dir)) == blockage || grid[n_loc] == '#' || grid[n_loc].nil?

        loc = n_loc
      end

      break if grid[loc.move(dir)].nil? || seen.include?(loc)

      dir = turn_right(dir)
      seen << loc unless (n_loc = loc.move(dir)) == blockage || grid[n_loc] == '#'
    end

    seen.include?(loc)
  end
end

file_contents = File.readlines('input.txt')

puts part1(file_contents)
puts part2(file_contents)
