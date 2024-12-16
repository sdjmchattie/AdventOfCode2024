module Grid
  DIRECTIONS = {
    n: [0, -1],
    e: [1, 0],
    s: [0, 1],
    w: [-1, 0],
    ne: [1, -1],
    se: [1, 1],
    sw: [-1, 1],
    nw: [-1, -1]
  }

  UDLR = [:n, :e, :s, :w]

  def self.turn_left(dir)
    {
      n: :w,
      w: :s,
      s: :e,
      e: :n
    }[dir]
  end

  def self.turn_right(dir)
    {
      n: :e,
      e: :s,
      s: :w,
      w: :n
    }[dir]
  end

  def self.opp_dir(dir)
    {
      n: :s,
      e: :w,
      s: :n,
      w: :e,
      ne: :sw,
      se: :nw,
      sw: :ne,
      nw: :se
    }[dir]
  end
end
