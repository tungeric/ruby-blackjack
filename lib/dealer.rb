require_relative 'player'

class Dealer < Player
  attr_reader :bets

  def initialize
    super("dealer", 0)

    @bets = {}
    @hand = nil
  end

  def place_bet(dealer, amt)
    raise "Dealer doesn't bet"
  end

  def play_hand(deck)
    until @hand.points >= 17
      @hand.hit(deck)
    end
  end

  def take_bet(player, amt)
    @bets[player] = amt
  end

  def pay_bets
    @bets.each do |player, amt|
      if player.hand.beats?(self.hand)
        player.pay_winnings(amt*2)
      elsif player.hand.ties?(self.hand)
        player.pay_winnings(amt)
      end
    end
  end

  def reveal_first_card
    card = @hand.cards[0]
    dealer_display = "|#{Card.display_values[card.value]}#{Card.display_suits[card.suit]}||??|"
    divider = dealer_display.chars.map { |char| "-"}.join("")
    puts divider
    puts dealer_display
    puts divider
  end
end
