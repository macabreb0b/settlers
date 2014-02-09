class Settlement < Intersection

  def initialize(player, board, number, pos)
    @player = player
    @color = @player.color
    super(board, number, pos)
  end

  def to_s
    @number.colorize(color: color)
  end


end