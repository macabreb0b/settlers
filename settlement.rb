class Settlement < Intersection

  attr_accessor :city

  def initialize(player, board, number, pos)
    @player = player
    @color = @player.color
    @city = false
    super(board, number, pos)
  end

  def to_s
    @number.colorize(color: color)
  end

  def pay(resource)
    return if resource == :desert
    n = ( city ? 2 : 1 )
    n.times do
      puts "#{player} gets one #{resource}."
      player.resources[resource] += 1
    end
  end
end