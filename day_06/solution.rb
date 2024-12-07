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

def jumps_from_blockage(blockage, grid)
  jumps = {}

  [:n, :e, :s, :w].each do |dir|
    turn_point = blockage.move(turn_right(dir))
    dest = turn_point

    while ['.', '^'].include?(grid[n_loc = dest.move(dir)])
      dest = n_loc
    end

    next_to_blockage = turn_point == dest # No valid jump if turns into another blockage.
    went_off_grid = grid[n_loc].nil?
    jumps[turn_point] = dest unless next_to_blockage || went_off_grid
  end

  jumps
end

def part2(file_contents)
  puts "\nPart 2\n======\n"
  marked = mark_route(Grid::Grid2D.new(file_contents))
  grid = Grid::Grid2D.new(file_contents)

  # Find jumps
  jumps = {}
  grid.find('#').each { |blockage| jumps.merge!(jumps_from_blockage(blockage, grid)) }

  # Find starting point
  start_loc = grid.find('^').first

  # Only place blockages where the original path goes, except the starting point
  marked.find('X').reject { |x| x == start_loc }.count do |blockage|
    # Create overrides for jumps with the new blockage
    override_jumps = jumps_from_blockage(blockage, grid)
    [:n, :e, :s, :w].each do |dir|
      dest = blockage.move(dir) # The point at which you reach the blockage.
      loc = dest # The current location while walking up to the blockage.
      next if grid[loc] == '#'

      adj_dir = turn_right(dir)
      loc = loc.move(dir)
      while ['.', '^'].include?(grid[loc])
        adjacent = loc.move(adj_dir)
        override_jumps[loc] = dest if grid[adjacent] == '#'
        loc = loc.move(dir)
      end
    end

    # Move to first blockage.
    loc = start_loc
    until grid[n_loc = loc.move(:n)] == '#' || n_loc == blockage
      loc = n_loc
    end

    jump_map = jumps.merge(override_jumps)
    seen = Set.new

    until seen.include?(loc) || loc.nil?
      seen << loc
      loc = jump_map[loc]
    end

    seen.include?(loc)
  end
end

file_contents = File.readlines('input.txt')

puts part1(file_contents)
puts part2(file_contents)
