#!/usr/bin/env ruby

require 'benchmark'

def create_disk(input)
  disk = [[0, input.shift]]
  file_id = 1
  while input.count > 0 do
    disk << [-1, input.shift]
    disk << [file_id, input.shift]
    file_id += 1
  end

  # Remove any zero length items.
  disk.reject { |item| item[1] == 0 }
end

def checksum(disk)
  index = 0
  sum = 0
  while (item = disk.shift)
    if item[0] == -1
      index += item[1]
      next
    end

    item[1].times do
      sum += item[0] * index
      index += 1
    end
  end

  sum
end

def part1(input)
  disk = create_disk(input.dup)

  while disk.any? { |item| item[0] == -1 }
    index = disk.index { |item| item[0] == -1 }
    prior_item = disk[index - 1]
    free_space = disk[index]
    last_item = disk[-1]

    # Reduce the free space; remove it if there's none left.
    free_space[1] -= 1
    disk.delete(free_space) if free_space[1] == 0

    # Increase the blocks consumed by the file; either increasing an existing area, or making a new one.
    if prior_item[0] == last_item[0]
      prior_item[1] += 1
    else
      disk.insert(index, [last_item[0], 1])
    end

    # Reduce the blocks for the moved file at the end of the disk; remove it if there's none left.
    last_item[1] -= 1
    disk.delete(last_item) if last_item[1] == 0

    # Delete the final blocks that only represent free space
    disk = disk[0..-2] while disk[-1][0] == -1
  end

  checksum(disk)
end

def part2(input)
  disk = create_disk(input.dup)
  id = disk[-1][0]

  while id >= 0 do
    # Find item to move and a candidate space for it.
    item_index = disk.index { |item| item[0] == id }
    id -= 1
    item_to_move = disk[item_index]

    space_before = disk[item_index - 1]
    space_after = disk[item_index + 1]
    space_before = nil if space_before[0] != -1
    space_after = nil if space_after && space_after[0] != -1

    new_space_index = disk.index { |item| item[0] == -1 && item[1] >= item_to_move[1] }

    # Only move items left.
    next if new_space_index.nil? || new_space_index > item_index

    space = disk[new_space_index]

    # Move the item.
    disk.insert(new_space_index, item_to_move.dup)
    space[1] -= item_to_move[1]
    disk.delete(space) if space[1] == 0

    # Turn the item into space.
    item_to_move[1] = [space_before, item_to_move, space_after].compact.sum { |item| item[1] }
    item_to_move[0] = -1
    disk.delete(space_before) unless space_before.nil?
    disk.delete(space_after) unless space_after.nil?

    # Delete the final blocks that only represent free space
    disk = disk[0..-2] while disk[-1][0] == -1
  end

  checksum(disk)
end

input = File.read('input.txt').chomp.split('').map(&:to_i)

p1_result = nil
p1_time = Benchmark.realtime { p1_result = part1(input) } * 1000
puts("Part 1 in #{p1_time.round(3)} ms\n  #{p1_result}\n\n")

p2_result = nil
p2_time = Benchmark.realtime { p2_result = part2(input) } * 1000
puts("Part 2 in #{p2_time.round(3)} ms\n  #{p2_result}\n\n")
