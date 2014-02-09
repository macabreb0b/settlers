class Game

  attr_reader :board

  def initialize(*players)
    @board = Board.new(self)
    @players = players
    assign_colors
    @current_player = @players.first
  end

  def play
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
    colors = [:yellow, :magenta, :red, :blue].shuffle
    @players.each do |player|
      player.color = colors.pop
      player.board = @board
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