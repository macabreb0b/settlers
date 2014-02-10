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
  # p1 = Player.new("Phil")
  # p2 = Player.new("Bernie")
  # p3 = Player.new("Quality")
  # p4 = Player.new("Mattress")
  #
  # g = Game.new(p1, p2, p3, p4)
  #
  # g.show
  #
  # g.play


  # x = g.board.find_all(Intersection).find { |ixs| ixs.number == "G2" }
#
#   p x.neighboring(Settlement)
#   p x.neighboring(Intersection)
#   p x.neighboring(Tile)
#
#   k1 = g.board.intersection_at("K1")
#
#   p k1.neighboring(Intersection)
#
#   g.show
#   g.board.rds

  # g.board.map.each do |row|
  #   p row
  # end

end