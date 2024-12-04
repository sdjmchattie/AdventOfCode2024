require_relative 'directions.rb'

module Grid
  class Grid2D
    def initialize(contents_array)
      @grid = contents_array.map { |line| line.chomp.split('') }
    end

    def width
      return 0 if @grid.empty?

      @grid[0].length
    end

    def height
      return 0 if @grid.empty?

      @grid.length
    end

    def [](x, y)
      return nil unless in_bounds?(x, y)

      @grid[y][x]
    end

    def []=(x, y, value)
      return unless in_bounds?(x, y)

      @grid[y][x] = value
    end

    def in_bounds?(x, y)
      x >= 0 && x < width && y >= 0 && y < height
    end

    def adjacent_values(x, y)
      DIRECTIONS.values.map do |dx, dy|
        self[x + dx, y + dy]
      end.compact
    end

    def adjacent_values_in_direction(x, y, direction, including_self: false)
      return [] unless self.in_bounds?(x, y)

      dx, dy = DIRECTIONS[direction]
      values = including_self ? [self[x, y]] : []

      loop do
        x += dx
        y += dy

        value = self[x, y]
        break if value.nil?

        values << value
      end

      values
    end
  end
end
