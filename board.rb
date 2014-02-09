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

  ROAD_PRINTER =
    ["\n            #{"⟋".white}  #{"⟍".white}    #{"⟋".white}  #{"⟍".white}    #{"⟋".white}  #{"⟍".white}              \n",
     "\n          #{"❘".white}       #{"❘".white}       #{"❘".white}       #{"❘".white}           \n",
     "\n       #{"⟋".white}    #{"⟍".white}  #{"⟋".white}    #{"⟍".white}  #{"⟋".white}    #{"⟍".white}  #{"⟋".white}    #{"⟍".white}    \n",
     "\n      #{"❘".white}       #{"❘".white}       #{"❘".white}       #{"❘".white}       #{"❘".white}       \n",
     "\n    #{"⟋".white}  #{"⟍".white}    #{"⟋".white}  #{"⟍".white}    #{"⟋".white}  #{"⟍".white}    #{"⟋".white}  #{"⟍".white}    #{"⟋".white}  #{"⟍".white} \n",
     "\n  #{"❘".white}       #{"❘".white}       #{"❘".white}       #{"❘".white}       #{"❘".white}       #{"❘".white}   \n",
     "\n    #{"⟍".white}  #{"⟋".white}    #{"⟍".white}  #{"⟋".white}    #{"⟍".white}  #{"⟋".white}    #{"⟍".white}  #{"⟋".white}    #{"⟍".white}  #{"⟋".white} \n",
     "\n      #{"❘".white}       #{"❘".white}       #{"❘".white}       #{"❘".white}       #{"❘".white}     \n",
     "\n        #{"⟍".white}   #{"⟋".white}  #{"⟍".white}    #{"⟋".white}  #{"⟍".white}    #{"⟋".white}  #{"⟍".white}   #{"⟋".white}      \n",
     "\n          #{"❘".white}       #{"❘".white}       #{"❘".white}       #{"❘".white}         \n",
     "\n            #{"⟍".white}  #{"⟋".white}    #{"⟍".white}  #{"⟋".white}    #{"⟍".white}  #{"⟋".white}         \n",
     ""
   ]

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

  def initialize(game)
    @map = build_map
   # @dev_cards = DevCard::CARDS.dup.shuffle
    place_tiles
    # build_roads
  end

  def roll
    d1 = (1..6).to_a.sample()
    d2 = (1..6).to_a.sample()
    d1 + d2
  end

  def [](pos)
    raise "invalid pos" unless valid_pos?(pos)
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
      string += Road::ROAD_PRINTER[ridx]
      display << string
    end
    display.each {|row| puts row }
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

  def payout(roll)
    paying_tiles = all_tiles.select! do |tile|
      tile.number == roll && !tile.robber
    end

    paying_tiles.each do |tile|
      resource = tile.resource
      tile.neighboring(Settlement).each { |settlement| settlement.pay(resource) }
    end
  end

  protected
    def valid_pos?(pos)
      pos.all? { |coord| coord.between?(0, 10) }
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

end
# str = '  XX
#   /  \  /
# XX DD XX
# || 04 ||
# XX    XX
#   \  /  \
#    XX
#   '
# puts str