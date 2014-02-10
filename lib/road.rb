class Road
  attr_reader :start_ixs, :end_ixs, :name
  attr_accessor :color

  def initialize(nodes, symbol)
    @start_ixs, @end_ixs = nodes
    @name = [@start_ixs.number, @end_ixs.number]
    @color = :yellow
    @symbol = symbol
  end

  def to_s
    @symbol.colorize(color: self.color)
  end
end