module Grid
  class Point2D
    attr_reader :x
    attr_reader :y

    def initialize(x, y)
      @x = x
      @y = y
    end

    def inspect
      "Point2D(#{@x},#{@y})"
    end

    def hash
      x.hash + y.hash
    end

    def ==(other)
      other.instance_of?(self.class) and self.x == other.x && self.y == other.y
    end

    def eql?(other)
      self == other
    end

    def move(direction)
      dx, dy = Grid::DIRECTIONS[direction]
      Point2D.new(x + dx, y + dy)
    end
  end
end
