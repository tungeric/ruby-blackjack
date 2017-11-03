require_relative 'player.rb'
require_relative 'dealer.rb'

class Game

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