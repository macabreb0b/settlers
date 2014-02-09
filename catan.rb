require 'colorize'
require_relative 'board'
require_relative 'tile'
require_relative 'intersection'
require_relative 'settlement'
require_relative 'game'
require_relative 'road'
require_relative 'player'
require_relative 'devcard'

if $PROGRAM_NAME == __FILE__
  p1 = Player.new("Phil")
  p2 = Player.new("Bernie")
  p3 = Player.new("Quality")
  p4 = Player.new("Mattress")

  g = Game.new(p1, p2, p3, p4)

  g.show
  puts p1.color
  p1.build_settlement("H2")

  # p1.settlements


  g.show

end