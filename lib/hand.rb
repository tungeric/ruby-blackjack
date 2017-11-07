require_relative 'card.rb'

class Hand
  attr_accessor :cards

  def self.deal_from(deck)
    cards = deck.draw(2)
    Hand.new(cards)
  end

  def initialize(cards)
    @cards = cards
  end

  def points
    sum = 0
    ace_count = 0
    @cards.each do |card|
      begin
        sum += card.blackjack_value
      rescue AceException
        ace_count +=1
        sum += 1
      end
    end
    if ace_count > 0
      if sum <=11
        sum += 10
      end
    end
    sum
  end

  def busted?
    self.points > 21
  end

  def hit(deck)
    raise "already busted" if busted?
    @cards.concat(deck.draw(1))
  end

  def beats?(other_hand)
    return false if busted?
    return true if other_hand.busted?
    points > other_hand.points
  end

  def ties?(other_hand)
    return false if busted?
    points == other_hand.points
  end

  def to_s
    card_display = @cards.map { |card| "|#{Card.display_values[card.value]}#{Card.display_suits[card.suit]}|" }
    card_display.join("")
  end

  def return_cards(deck)
    deck.return(@cards)
    @cards = []
  end

end