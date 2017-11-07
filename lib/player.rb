require_relative 'hand.rb'

class Player
  attr_reader :name, :bankroll
  attr_accessor :hand

  def initialize(name, bankroll=1000)
    @name = name
    @bankroll = bankroll
    @hand = nil
  end
  
  def reset_bankroll(amt)
    @bankroll = amt
  end

  def rename(name)
    @name = name
  end

  def pay_winnings(bet_amt)
    @bankroll += bet_amt
  end

  def split_hand(hand, deck)
    @hand = hand
    @hand.hit(deck)
  end

  def return_cards(deck)
    @hand.return_cards(deck)
    # @hand = nil
  end

  def place_bet(dealer, bet_amt)
    raise "player can't cover bet" if bet_amt > @bankroll
    @bankroll -= bet_amt
    dealer.take_bet(self, bet_amt)
  end

  def transfer_money(other_player, amt)
    other_player.add_money(amt)
    @bankroll -= amt
  end

  def add_money(amt)
    @bankroll += amt
  end

  def choose_move
    puts "Choose a move:"
    puts "1 - Hit"
    puts "2 - Stand"
    puts "3 - Double down"
    if @hand.cards.length == 2 && Card.display_values[@hand.cards[0].value] == Card.display_values[@hand.cards[1].value]
      puts "4 - Split"
    end
    move = gets.chomp
  end

end
