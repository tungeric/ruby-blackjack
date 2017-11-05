require_relative 'card'

class Deck

  def self.all_cards
    cards = []
    Card.suits.each do |suit|
      Card.values.each do |value|
        cards << Card.new(suit, value)
      end
    end
    cards
  end

  def initialize(cards = Deck.all_cards)
    @cards = cards
    shuffle!
  end

  def shuffle!
    @cards.shuffle!
  end

  def draw(n)
    taken_cards = []
    raise "not enough cards" if @cards.count < n
    i = 0
    while i < n
      taken_cards << @cards.shift
      i+=1
    end
    taken_cards
  end

end