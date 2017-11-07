require_relative 'player.rb'
require_relative 'dealer.rb'
require_relative 'deck.rb'
require 'byebug'

class Game
  attr_reader :current_player, :players, :deck
  
  def initialize
    @players = create_players
    @current_player = players[0]
    @dealer = Dealer.new
    @deck = Deck.new
    @split = false
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
      system "clear"
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
    idx = @players.index(@current_player)
    num_players = @players.length
    @current_player = @players[(idx+1)%num_players]
    puts "Hit Enter to end turn!"
    placeholder = gets.chomp
  end

  def play
    continue = "Y"
    while continue.downcase == "y" && @players.length >= 1
      deal
      @players.length.times do
        system "clear"
        puts "Hit Enter to play as #{@current_player.name}!"
        placeholder = gets.chomp
        place_bet
        take_turn
        switch_players
      end
      @dealer.play_hand(@deck)
      handle_bets
      display_all
      return_cards
      unsplit_players if @split == true
      check_bankrolls
      continue = continue?
    end
    puts "GAME OVER. THANK YOU FOR PLAYING BLACKJACK!"
  end

  def check_bankrolls
    system "clear"
    @players.each do |player|
      if player.bankroll <= 0
        puts "#{player.name}, sorry but you have no money left. Goodbye."
      else
        puts "#{player.name}, your current bankroll is $#{player.bankroll}"
      end
    end
    @players = @players.reject { |player| player.bankroll <=0 }
  end

  def unsplit_players
    combined_bankroll = 0
    split_player = nil
    @players.each do |player|
      combined_bankroll += player.bankroll if player.name.include?("-split")
      split_player = player if player.name.include?("-split1")
    end
    @players.reject! { |player| player.name.include?("-split2") }
    split_player.rename(split_player.name[0...-7])
    split_player.reset_bankroll(combined_bankroll)
    @split = false
  end

  def continue?
    return "N" if @players.length < 1
    puts ""
    puts "Continue game? (Y/N)"
    begin
      continue = gets.chomp
      raise "not a valid response" if continue.downcase != "y" && continue.downcase != "n"
    rescue
      puts "Please choose Y or N"
      retry
    end
    continue
  end


  def place_bet
    begin
      puts "#{@current_player.name}, choose an amount to bet! (You currently have $#{@current_player.bankroll})"
      bet_amt = Integer(gets.chomp)
      @current_player.place_bet(@dealer, bet_amt)
    rescue
      puts "Please enter a valid bet"
      retry
    end
  end

  def take_turn
    move = 1
    while move != '2' && !@current_player.hand.busted?
      display
      move = @current_player.choose_move
      case move
      when '1'
        @current_player.hand.hit(@deck)
      when '3'
        double_down
        break
      when '4'
        @split = true
        split
      end
    end
    if @current_player.hand.busted?
      display
      puts "YOU BUSTED!"
    end
  end

  def double_down
    bet_amt = @dealer.bets[@current_player]
    @dealer.bets[@current_player] = bet_amt * 2
    @current_player.hand.hit(@deck)
    display
  end

  def split
    idx = @players.index(@current_player)
    bet_amt = @dealer.bets[@current_player]
    split_player = Player.new("#{@current_player.name}-split2", 0)
    @current_player.transfer_money(split_player, bet_amt)
    split_player.place_bet(@dealer, bet_amt)
    @current_player.rename("#{current_player.name}-split1")
    @players.insert(idx + 1, split_player)
    hand1 = Hand.new([@current_player.hand.cards[0]])
    hand2 = Hand.new([@current_player.hand.cards[1]])
    @current_player.split_hand(hand1, @deck)
    @players[idx+1].split_hand(hand2, @deck)
    take_turn
    switch_players
  end

  def handle_bets
    @dealer.pay_bets
  end

  def return_cards
    @players.each do |player|
      player.return_cards(@deck)
    end
    @dealer.return_cards(@deck)
    @deck.shuffle!
  end

  def deal
    @players.each do |player|
      player.hand = Hand.deal_from(@deck)
    end
    @dealer.hand = Hand.deal_from(@deck)
  end

  def display
    system "clear"
    player_hand = @current_player.hand.to_s
    player_points = @current_player.hand.points
    divider = player_hand.chars.map { |char| "-"}.join("")
    puts "Current player: #{@current_player.name}"
    puts ""
    puts ""
    puts "Dealer's cards:"
    @dealer.reveal_first_card
    puts ""
    puts "Your cards:"
    puts divider
    puts player_hand
    puts divider
    puts "Your points: #{player_points}"
    puts ""
  end

  def display_all
    system "clear"
    dealer_hand = @dealer.hand.to_s
    dealer_points = @dealer.hand.points
    dealer_divider = dealer_hand.chars.map { |char| "-"}.join("")

    puts "Dealer's hand:"
    puts dealer_divider
    puts dealer_hand
    puts dealer_divider
    puts "Dealer's points: #{dealer_points}"
    puts ""

    @players.each do |player|
      player_hand = player.hand.to_s
      player_points = player.hand.points
      player_divider = player_hand.chars.map { |char| "-"}.join("")

      puts "Player: #{player.name}"
      puts player_divider
      puts player_hand
      puts player_divider
      puts "#{player.name}'s points: #{player_points}"
      if player.hand.beats?(@dealer.hand)
        print "#{player.name} wins! "
      else
        print "#{player.name} loses. "
      end
      puts "Remaining bankroll: $#{player.bankroll}"
      puts ""
    end
    puts "Press Enter to continue"
    temp = gets.chomp
  end

end

a = Game.new
