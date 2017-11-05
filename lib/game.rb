require_relative 'player.rb'
require_relative 'dealer.rb'
require_relative 'table.rb'
require_relative 'deck.rb'

class Game
  attr_reader :current_player, :players, :deck
  
  def initialize
    @players = create_players
    @current_player = players[0]
    @deck = Deck.new
    play
  end

  def get_num_players
    puts "How many players?"
    begin
      num_players = Integer(gets.chomp)
      unless num_players > 0
        raise ArgumentError
      end
    rescue ArgumentError
      puts "Please enter a number greater than 0"
      retry
    end
    num_players
  end

  def create_players
    num = get_num_players
    player_names = []
    1.upto(num) do |idx|
      puts "Player #{idx}, please enter your name"
      player_names << gets.chomp
    end
    players = []
    player_names.each do |name|
      players << Player.new(name)
    end
    players
  end

  def switch_players
    idx = players.find(@current_player)
  end

  def play
    i = 0
    deal
    while i < 3
      @current_player.take_turn
      switch_players
    end
  end

  def deal
    @players.each do |player|
      player.hand = Hand.deal_from(@deck)
    end
    @players.each do |player|
      puts player.hand.points
    end
  end

end

a = Game.new
