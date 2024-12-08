require_relative 'directions.rb'
require_relative 'point_2d.rb'

module Grid
  class Grid2D
    def initialize(contents_array)
      @grid = contents_array.map { |row| row.chomp.split('') }
    end

    def empty_dup
      Grid2D.new(['.'.ljust(width)] * height)
    end

    def width
      return 0 if @grid.empty?

      @grid[0].length
    end

    def height
      return 0 if @grid.empty?

      @grid.length
    end

    def [](point)
      return nil unless in_bounds?(point)

      @grid[point.y][point.x]
    end

    def []=(point, value)
      return unless in_bounds?(point)

      @grid[point.y][point.x] = value
    end

    def all_chars
      @grid.flatten.uniq.sort
    end

    def count(char = nil)
      return width * height if char.nil?

      @grid.reduce(0) { |acc, row| acc + row.count { |e| e == char } }
    end

    def find(char)
      @grid.each_with_index.flat_map do |row, y|
        row.each_with_index.map do |c, x|
          next if c != char

          Point2D.new(x, y)
        end
      end.compact
    end

    def in_bounds?(point)
      point.x >= 0 && point.x < width && point.y >= 0 && point.y < height
    end

    def adjacent_values(point)
      DIRECTIONS.values.map do |dx, dy|
        self[point.x + dx, point.y + dy]
      end.compact
    end

    def adjacent_values_in_direction(point, direction, including_self: false)
      return [] unless self.in_bounds?(point)

      cur_point = Point2D.new(point.x, point.y)
      dx, dy = DIRECTIONS[direction]
      values = including_self ? [self[cur_point]] : []

      loop do
        cur_point = Point2D.new(cur_point.x + dx, cur_point.y + dy)
        value = self[cur_point]
        break if value.nil?

        values << value
      end

      values
    end
  end
end
