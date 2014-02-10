# -*- coding: utf-8 -*-

class Intersection
  attr_accessor :player, :color
  attr_reader :pos, :number, :board

  def self.build_settlement(player)
    Settlement.new(player, board, number, pos)
  end

  def initialize(board, number, pos)
    @board, @number, @pos = board, number, pos
    # @color = :white
  end

  def neighboring(klass)
    y, x = pos
    neighbors = []
    (-1..1).to_a.each do |ydiff|
      (-1..1).to_a.each do |xdiff|
        next if xdiff == 0 && ydiff == 0
        neighbors << @board[[y + ydiff, x + xdiff]]
      end
    end
    neighbors.select!  { |neighbor| neighbor.is_a?(klass) }.uniq
  end

  def to_s
    @number.colorize(color: :yellow)
  end

end

colors = [#:black,
 :red,
 :green,
 :yellow,
 :blue,
 :magenta,
 #:cyan,
 :white,
 #:default
]