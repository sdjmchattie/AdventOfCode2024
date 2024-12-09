#!/usr/bin/env ruby

require 'benchmark'

def create_disk(input)
  disk = [0] * input.shift
  file_id = 1
  while input.count > 0 do
    disk += [-1] * input.shift
    disk += [file_id] * input.shift
    file_id += 1
  end

  disk
end

def checksum(disk)
  disk.each_with_index.reduce(0) { |cs, (b, i)| cs + [0, b * i].max }
end

def part1(input)
  disk = create_disk(input.dup)

  gap_index = 0
  data_index = disk.count - 1

  loop do
    gap_index += 1 until disk[gap_index] == -1 || gap_index >= disk.count
    data_index -= 1 while disk[data_index] == -1 || data_index < 0

    break if gap_index > data_index

    disk[gap_index] = disk[data_index]
    disk[data_index] = -1
  end

  checksum(disk)
end

def part2(input)
  disk = create_disk(input.dup)

  moved = Set.new
  data_end = disk.count
  while data_end >= 0
    data_end -= 1
    file_id = disk[data_end]
    next if file_id == -1 || moved.include?(file_id)

    moved << file_id

    data_start = data_end.downto(0).find { |index| disk[index] != file_id }
    break if data_start.nil?

    data_length = data_end - data_start
    data_start += 1
    data_end = data_start

    space_start = 0
    while space_start < data_start
      space_start += 1
      next unless disk[space_start] == -1

      space_end = (space_start...disk.count).find { |index| disk[index] != -1 }
      break if space_end - space_start >= data_length

      space_start = space_end
    end

    next if space_start >= data_start

    data_length.times do |index|
      disk[data_start + index] = -1
      disk[space_start + index] = file_id
    end
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
