class Game

  attr_reader :board, :players

  def initialize(*players)
    @board = Board.new(self)
    @players = players
    assign_colors
    @current_player = nil
  end

  def play
    get_player_order
    first_round_build

    until game_over?
      roll = @board.roll
      puts "#{@current_player} rolled a #{roll}"
      if roll == 7
        @current_player.move_robber
      else
        @board.payout(roll)
      end
      @current_player.play_turn
      @current_player = @players.rotate!.first
    end
  end

  def assign_colors
    colors = [:white, :magenta, :red, :blue].shuffle
    @players.each do |player|
      player.color = colors.pop
      player.board = @board
    end
  end

  def get_player_order
    max_roll = 0
    high_rollers = @players
    while high_rollers.count > 1
      high_rollers.each do |player|
        roll = @board.roll
        puts "#{player} rolled #{roll}."
        if roll > max_roll
          max_roll = roll
          high_rollers = [player]
        elsif roll == max_roll
          high_rollers << player
        end
      end
    end
    @current_player = high_rollers[0]
    @players.rotate! until @players[0] == @current_player
  end

  def first_round_build
    puts "Starting with #{@current_player} - Each player builds one SETTLEMENT and one ROAD."
    @players.each do |player|
      player.first_build(1)
    end
    puts "Reverse order - Each player builds one SETTLEMENT and one ROAD."
    @players.reverse.each do |player|
      player.first_build(2)
    end
  end

  def show
    puts @board
  end

  def winner?
  end

  def game_over?
  end
end