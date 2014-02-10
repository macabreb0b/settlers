# -*- coding: utf-8 -*-

require 'debugger'

class Board

  IXS = [[0,0,0,1,0,1,0,1,0,0,0],
  [0,0,1,0,1,0,1,0,1,0,0],
  [0,0,1,0,1,0,1,0,1,0,0],
  [0,1,0,1,0,1,0,1,0,1,0],
  [0,1,0,1,0,1,0,1,0,1,0],
  [1,0,1,0,1,0,1,0,1,0,1],
  [1,0,1,0,1,0,1,0,1,0,1],
  [0,1,0,1,0,1,0,1,0,1,0],
  [0,1,0,1,0,1,0,1,0,1,0],
  [0,0,1,0,1,0,1,0,1,0,0],
  [0,0,1,0,1,0,1,0,1,0,0],
  [0,0,0,1,0,1,0,1,0,0,0]]

  TILE_COORDS = [
    [[1, 3], [2, 3]],
    [[1, 5], [2, 5]],
    [[1, 7], [2, 7]],
    [[3, 2], [4, 2]],
    [[3, 4], [4, 4]],
    [[3, 6], [4, 6]],
    [[3, 8], [4, 8]],
    [[5, 1], [6, 1]],
    [[5, 3], [6, 3]],
    [[5, 5], [6, 5]],
    [[5, 7], [6, 7]],
    [[5, 9], [6, 9]],
    [[7, 2], [8, 2]],
    [[7, 4], [8, 4]],
    [[7, 6], [8, 6]],
    [[7, 8], [8, 8]],
    [[9, 3], [10, 3]],
    [[9, 5], [10, 5]],
    [[9, 7], [10, 7]],
  ]

  NUMBERS = [2, 3, 3, 4, 4, 5, 5, 6, 6, 8,
    8, 9, 9, 10, 10, 11, 11, 12]

  attr_reader :rds, :map

  def initialize(game)
    @map = build_map
    place_tiles
    @rds = build_roads

    @longest_road = 4
    @largest_army = 2
  end

  def roll
    d1 = (1..6).to_a.sample()
    d2 = (1..6).to_a.sample()
    d1 + d2
  end

  def [](pos)
    return nil unless valid_pos?(pos)
    y, x = pos
    @map[y][x]
  end

  def []=(pos, object)
    y, x = pos
    @map[y][x] = object
  end

  def to_s
    system "clear"
    display = []
    @map.each_with_index do |row, ridx|
      string = ""
      row.each do |tile|
        if tile.nil?
          string += "^^^^".cyan
        elsif tile.is_a?(Tile)
          string += (ridx.even? ? " #{tile}  " : " #{tile.short} " )
        else
          string += " #{tile} "
        end
      end
      string += road_printer[ridx]
      display << string
    end
    display.each {|row| puts row }
  end

  def inspect
    nil
  end

  def find_all(object)
    objects = []
    @map.each do |row|
      row.each do |tile|
        objects << tile if tile.is_a?(object)
      end
    end
    objects
  end

  def intersection_at(number)
    self.find_all(Intersection).find { |ixs| ixs.number == number }
  end

  def settlement_at(number)
    self.find_all(Settlement).find { |ixs| ixs.number == number }
  end

  def payout(roll)
    settlements = find_all(Settlement)

    settlements.each do |settlement|
      settlement.neighboring(Tile).each do |tile|
        if tile.number == roll && tile.robber == false
          settlement.pay(tile.resource)
        end
      end
    end
  end

  def find_road_path(ixs)
    ixs1, ixs2 = ixs
  end

  def get_road_at(numbers)
    name1, name2 = numbers
    rds.find { |road| road.name.include?(name1) && road.name.include?(name2) }
  end

  def get_roads_at(number)
    rds.select { |road| road.name.include?(number) }
  end

  protected
    def valid_pos?(pos)
      pos.all? { |coord| coord.between?(0, 11) }
    end

    def build_map
      map = []
      letter = "A"
      IXS.each_with_index do |row, ridx|
        arr = []
        number = 1
        row.each_with_index do |col, cidx|
          if col == 0
            arr << nil
          else
            arr << Intersection.new(self, "#{letter}#{number.to_s}", [ridx, cidx])
            number += 1
          end
        end
        letter.next!
        map << arr
      end
      map
    end

    def place_tiles
      tiles = []
      numbers = NUMBERS.shuffle
      Tile.freqs.each do |resource, freq|
        freq.times do
          if resource != :desert
            tiles << Tile.new(resource, numbers.pop)
          else
            tiles << Tile.new(resource, 0, robber = true)
          end
        end
      end

      tiles = tiles.shuffle
      TILE_COORDS.each do |coord|
        tile = tiles.pop
        ty, tx = coord[0]
        by, bx = coord[1]
        @map[ty][tx] = tile
        @map[by][bx] = tile
      end
    end

    def build_roads
      roads = []
      @map.each_with_index do |row, ridx|
        row.each_with_index do |tile, cidx|
          if tile.is_a?(Intersection)
            neighbors = tile.neighboring(Intersection)

            neighbors.each do |neighbor|

              name1 = tile.number
              name2 = neighbor.number

              unless roads.any? { |road| road.name.include?(name1) && road.name.include?(name2) }
                symbol = "?"
                if ridx.odd?
                  symbol = "❘"
                elsif ridx < 5
                  symbol = ( name1[1].to_i == name2[1].to_i ? "⟋" : "⟍" )
                else
                  symbol = ( name1[1].to_i == name2[1].to_i ? "⟍" : "⟋" )
                end

                roads << Road.new([tile, neighbor], symbol)
              end
            end
          end
        end
      end
      roads
    end

    def road_printer
      ["\n            #{@rds[0]}  #{@rds[1]}    #{@rds[2]}  #{@rds[3]}    #{@rds[4]}  #{@rds[5]}              \n",
         "\n          #{@rds[6]}       #{@rds[7]}       #{@rds[8]}       #{@rds[9]}           \n",
         "\n       #{@rds[10]}    #{@rds[11]}  #{@rds[12]}    #{@rds[13]}  #{@rds[14]}    #{@rds[15]}  #{@rds[16]}    #{@rds[17]}    \n",
         "\n      #{@rds[18]}       #{@rds[19]}       #{@rds[20]}       #{@rds[21]}       #{@rds[22]}       \n",
         "\n    #{@rds[23]}  #{@rds[24]}    #{@rds[25]}  #{@rds[26]}    #{@rds[27]}  #{@rds[28]}    #{@rds[29]}  #{@rds[30]}    #{@rds[31]}  #{@rds[32]} \n",
         "\n  #{@rds[33]}       #{@rds[34]}       #{@rds[35]}       #{@rds[36]}       #{@rds[37]}       #{@rds[38]}   \n",
         "\n    #{@rds[39]}  #{@rds[40]}    #{@rds[41]}  #{@rds[42]}    #{@rds[43]}  #{@rds[44]}    #{@rds[45]}  #{@rds[46]}    #{@rds[47]}  #{@rds[48]} \n",
         "\n      #{@rds[49]}       #{@rds[50]}       #{@rds[51]}       #{@rds[52]}       #{@rds[53]}     \n",
         "\n        #{@rds[54]}   #{@rds[55]}  #{@rds[56]}    #{@rds[57]}  #{@rds[58]}    #{@rds[59]}  #{@rds[60]}   #{@rds[61]}      \n",
         "\n          #{@rds[62]}       #{@rds[63]}       #{@rds[64]}       #{@rds[65]}         \n",
         "\n            #{@rds[66]}  #{@rds[67]}    #{@rds[68]}  #{@rds[69]}    #{@rds[70]}  #{@rds[71]}         \n",
         ""
       ]
   end



end
