require_relative 'directions.rb'
require_relative 'point_2d.rb'

module Grid
  class Grid2D
    def initialize(contents_array = nil, width: 0, height: 0)
      if contents_array
        @grid = contents_array.map { |row| row.chomp.split('') }
      elsif width > 0 && height > 0
        @grid = Array.new(height) { ['.'] * width }
      else
        raise 'Invalid initialization arguments.'
      end
    end

    def to_s
      @grid.map(&:join).join("\n")
    end

    def inspect
      "<Grid2D width=#{width} height=#{height}>\n#{self}"
    end

    def empty_dup
      Grid2D.new(width:, height:)
    end

    def width
      return 0 if @grid.empty?

      @grid[0].length
    end

    def height
      return 0 if @grid.empty?

      @grid.length
    end

    def parse_coords(point_or_x, y)
      return point_or_x.x, point_or_x.y if point_or_x.instance_of?(Point2D)
      return point_or_x, y if y.kind_of?(Numeric)

      raise 'Argument types are invalid'
    end

    def [](point_or_x, y = nil)
      x, y = parse_coords(point_or_x, y)
      return nil unless in_bounds?(x, y)

      @grid[y][x]
    end

    def []=(point_or_x, y = nil, value)
      x, y = parse_coords(point_or_x, y)
      return unless in_bounds?(x, y)

      @grid[y][x] = value
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

    def in_bounds?(point_or_x, y = nil)
      x, y = parse_coords(point_or_x, y)

      x >= 0 && x < width && y >= 0 && y < height
    end

    def adjacent_coords((x, y), dirs = nil)
      dirs = DIRECTIONS.keys if dirs.nil?
      dirs.map do |dir|
        [x + DIRECTIONS[dir][0], y + DIRECTIONS[dir][1]]
      end.select { |adj| self.in_bounds?(adj[0], adj[1]) }
    end

    def adjacent_points(point, dirs = nil)
      adjacent_coords([point.x, point.y], dirs).map { |coord| Point2D.new(coord[0], coord[1]) }
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
