# -*- coding: utf-8 -*-

class Intersection
  attr_accessor :player, :color
  attr_reader :pos, :number

  def self.build_settlement(player)
    Settlement.new(player, board, number, pos)
  end

  def initialize(board, number, pos)
    @board, @number, @pos = board, number, pos
    #@color = :white
  end

  def neighboring(klass)
    y, x = pos
    neighbors = []
    (-1..1).to_a.each do |ydiff|
      (-1..1).to_a.each do |xdiff|
        neighbors << @board[[y + ydiff, x + xdiff]]
      end
    end
    neighbors.select! { |neighbor| neighbor.is_a?(klass) }
    neighbors.uniq if klass == Tile
  end

  def to_s
    @number.colorize(color: :white)
  end

end

colors = [:black,
 :red,
 :green,
 :yellow,
 :blue,
 :magenta,
 :cyan,
 :white,
 :default,
 :light_black,
 :light_red,
 :light_green,
 :light_yellow,
 :light_blue,
 :light_magenta,
 :light_cyan,
 :light_white]