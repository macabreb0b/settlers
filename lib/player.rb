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

    @choices = {
      1 => "Shop",
      2 => "Use Development Card",
      3 => "Trade"
    }

    @shop = {
      road: {brick: 1, wood: 1},
      settlement: {brick: 1, wood: 1, sheep: 1, wheat: 1},
      city: {ore: 3, wheat: 2},
      development_card: {sheep: 1, wheat: 1, ore: 1}
    }

    @victory_points = []
    @longest_road = false
    @largest_army = false
    @army = 0
  end

  def to_s
    color.to_s.upcase
  end

  def victory_points
    sum = @victory_points.count
    stmts = @board.find_all(Settlement).select { |stm| stm.color == self.color }
    stmts.each do |stmt|
      sum += ( stmt.city ? 2 : 1 )
    end
    sum += bonuses
  end # count up settlements, cities, victory points, and bonuses

  def play_turn
    used_devcard = false

    puts "#{self}'s turn - you have:"
    @resources.each do |k, v|
      puts "#{v} #{k}"
    end

    @devcards.each { |card| puts "devcard - #{card.type}"}

    while true
      puts "Would you like to do anything? (Y/N)"
      input = gets.chomp.upcase
      break if input == "N"
      begin
        puts "OK - please enter one of the following numbers:"
        puts @choices
        input = gets.chomp.to_i
        raise "not a valid input" unless @choices.keys.include?(input)
      rescue => e
        puts e
        retry
      end
    end
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

  def use_dev_card
    # call dev_card method with a case switch
  end

  def shop_display
    display = []
    @shop.each do |item, cost|
      show = true
      price = []
      cost.each do |resource, n|
        if @resources[resource] < n
          show = false
        end
        price << "#{n} #{resource}"
      end
      if show
        display << "#{item} - #{price.join(', ')}"
      end
    end
    display.each_with_index do |item, idx|
      puts "#{idx + 1}. #{item}"
    end
  end

  def buy
    puts "#{self} - What would you like to buy?"
    shop_display

    choice = gets.chomp.to_sym
    case choice
    when :road
      puts "Build ROAD - OK, from where to where?"
      build_road(gets.chomp.upcase.split)
    when :settlement
      puts "Build SETTLEMENT - OK, at what intersection?"
      build_settlement(gets.chomp.upcase)
    when :city
      puts "Build CITY - OK, at what settlement?"
      build_city(gets.chomp.upcase)
    when :development_card
      puts "Buy DEVELOPMENT CARD - OK!"
      buy_development_card
    end
    puts board
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
