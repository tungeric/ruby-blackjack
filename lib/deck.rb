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
    # @cards.shuffle!
    puts Card.display_values[@cards[0].value]
    @cards.sort_by! { |card| Card.display_values[card.value] }
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

  def return(cards)
    cards.each { |card| @cards << card }
    shuffle!
  end

end