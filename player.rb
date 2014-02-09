class Player

  attr_accessor :resources, :board, :color

  def initialize(name)
    @name = name
    @resources = {
      sheep: 0,
      logs: 0,
      wheat: 0,
      brick: 0,
      ore: 0
    }
  end

  def to_s
    name
  end

  def action_points
  end

  def build_settlement(number)
    ix = @board.find_all(Intersection).find { |ixs| ixs.number == number }
    @board[ix.pos] = Settlement.new(self, @board, number, ix.pos)
  end

  def build_road
  end

  def play_dcard
  end

  def shop
  end

  def move_robber
  end
end
