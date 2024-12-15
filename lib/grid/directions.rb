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

  def opp_dir(dir)
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
