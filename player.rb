class Player

  attr_accessor :resources, :board, :color, :name

  def initialize(name)
    @name = name
    @resources = {
      sheep: 0,
      wood: 0,
      wheat: 0,
      brick: 0,
      ore: 0
    }
  end

  def to_s
    color.to_s.upcase
  end

  def action_points
  end

  def build_settlement(number, first = false)
    ix = @board.find_all(Intersection).find { |ixs| ixs.number == number }
    raise "Too close to another settlement." if !ix.neighboring(Settlement).empty?
    unless @board.get_roads_at(number).any? { |road| road.color == color } || first == true
      raise "No adjacent roads or settlements to build from."
    end
    @board[ix.pos] = Settlement.new(self, @board, number, ix.pos)
    puts "Built a SETTLEMENT"
  end

  def build_road(numbers)
    name1, name2 = numbers
    road = @board.get_road_at([name1, name2])

    raise "Not a valid road." unless road
    raise "Another player already owns a road there." unless road.color == :yellow
    if @board.settlement_at(name1)
      raise "You are blocked." if @board.settlement_at(name1).color != color
    end
    unless @board.get_roads_at(name1).any? { |road| road.color == color } ||
      @board.settlement_at(name1).color == color
      raise "No adjacent roads or settlements to build from."
    end

    road.color = self.color
    puts "Built a ROAD"
  end

  def play_dcard
  end

  def build
    begin
      puts "#{self} - What would you like to build?"
      construct = gets.chomp.to_sym
      case construct
      when :road
        puts "Build ROAD - OK, from where to where?"
        build_road(gets.chomp.upcase.split)
      when :settlement
        puts "Build SETTLEMENT - OK, at what intersection?"
        build_settlement(gets.chomp.upcase)
      when :city
        puts "Build CITY - OK, at what settlement?"
        build_city(gets.chomp.upcase)
      end
    rescue => e
      puts e
      retry
    end
    puts board
    puts "Build more? (Y/N)"
    build if gets.chomp.upcase == "Y"
  end

  def first_build(round)
    ixs = nil
    begin
      puts "#{self} - where do you want your settlement?"
      ixs = gets.chomp.upcase
      build_settlement(ixs, true)
      if round == 2
        stl = @board.settlement_at(ixs)
        stl.neighboring(Tile).each do |tile|
          next if tile.resource == :desert
          puts "#{self} gets one #{tile.resource}."
          self.resources[tile.resource] += 1
        end
      end
    rescue => e
      puts e
      retry
    end

    begin
      puts "Build ROAD - OK, from #{ixs} to where?"
      next_ixs = gets.chomp.upcase
      build_road([ixs, next_ixs])
    rescue => e
      puts e
      retry
    end
    puts board
  end

  def move_robber
  end
end
