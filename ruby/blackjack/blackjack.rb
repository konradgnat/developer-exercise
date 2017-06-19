class Card
  attr_accessor :suite, :name, :value

  def initialize(suite, name, value)
    @suite, @name, @value = suite, name, value
  end
end

class Deck
  attr_accessor :playable_cards
  SUITES = [:hearts, :diamonds, :spades, :clubs]
  NAME_VALUES = {
    :two   => 2,
    :three => 3,
    :four  => 4,
    :five  => 5,
    :six   => 6,
    :seven => 7,
    :eight => 8,
    :nine  => 9,
    :ten   => 10,
    :jack  => 10,
    :queen => 10,
    :king  => 10,
    :ace   => [11, 1]}

  def initialize
    shuffle
  end

  def deal_card
    random = rand(@playable_cards.size)
    @playable_cards.delete_at(random)
  end

  def shuffle
    @playable_cards = []
    SUITES.each do |suite|
      NAME_VALUES.each do |name, value|
        @playable_cards << Card.new(suite, name, value)
      end
    end
  end
end

class Hand
  attr_accessor :cards, :score

  def initialize
    @cards = []
    @score = 0
  end

  def new_card(deck)
    @cards << deck.deal_card
  end

  def display_hand
    @score = 0
    cards.each do |card|
      printf "#{card.name} of #{card.suite} "
      if card.value.kind_of?(Array)
        if @score + card.value[0] > 21
          @score += card.value[1]
          printf "(#{card.value[1]}) "
        else
          @score += card.value[0]
          printf "(#{card.value[0]}) "
        end
      else 
        @score += card.value
        printf "(#{card.value}) "
      end
    end
    puts "\nTotal: #{@score}"
  end

  def display_card
    if cards[0].value.kind_of?(Array)
      puts "#{cards[0].name} of #{cards[0].suite} (#{cards[0].value[0]})"
    else
      puts "#{cards[0].name} of #{cards[0].suite} (#{cards[0].value})"
    end
  end

  def stand_or_hit
    input = ""
    while (input != "H" && input != "S") do
      puts "Stand or Hit? Enter S or H"
      input = gets.chomp.upcase
    end
    return input
  end
end

class Blackjack
  attr_accessor :deck, :player, :dealer

  def initialize
    @deck = Deck.new
    @player = Hand.new
    @dealer = Hand.new
    2.times { player.new_card(@deck) }
    2.times { dealer.new_card(@deck) }
  end

  def start
    puts "PLayer cards: "
    @player.display_hand
    puts "\nDealer cards: "
    @dealer.display_card
    if @player.score == 21
      puts "Blackjack! Player wins!"
      play_or_quit
    end
    while @player.stand_or_hit != "S" do
      puts "You chose Hit"
      player.new_card(@deck) 
      puts "Your cards: "
      @player.display_hand
      if @player.score > 21
        puts "Player busts! Dealer wins!"
        play_or_quit
      elsif @player.score == 21
        puts "Blackjack! Player wins!"
        play_or_quit
      end
    end
    puts "You chose Stand"
    @dealer.new_card(@deck) 
    puts "Dealer cards: "
    @dealer.display_hand
    if @dealer.score < 17
      @dealer.new_card(@deck) 
      puts "Dealer cards: "
      @dealer.display_hand
    end
    if @dealer.score > 21
      puts "Dealer busts! Player Wins!"
      play_or_quit
    end
    if @dealer.score == 21
      puts "Blackjack! Dealer wins!"
      play_or_quit
    end
    decide_winner
    play_or_quit
  end

  def play_or_quit
    play_or_quit = ""
    while (play_or_quit != "Y" && play_or_quit != "N") do
      puts "Play again? Enter Y or N"
      play_or_quit = gets.chomp.upcase
    end
    if play_or_quit == "N"
      puts "You chose to end game, exiting..."
      exit(0)
    else
      puts "You chose to play a new game, new game starting..."
      newgame = Blackjack.new
      newgame.start
    end
  end

  def decide_winner
    if @player.score > @dealer.score
      puts "Player wins!"
      play_or_quit
    else
      puts "Dealer wins!"
      play_or_quit
    end
  end
end

blackjack = Blackjack.new
blackjack.start

require 'test/unit'

class CardTest < Test::Unit::TestCase
  def setup
    @card = Card.new(:hearts, :ten, 10)
  end
  
  def test_card_suite_is_correct
    assert_equal @card.suite, :hearts
  end

  def test_card_name_is_correct
    assert_equal @card.name, :ten
  end
  def test_card_value_is_correct
    assert_equal @card.value, 10
  end
end

class DeckTest < Test::Unit::TestCase
  def setup
    @deck = Deck.new
  end
  
  def test_new_deck_has_52_playable_cards
    assert_equal @deck.playable_cards.size, 52
  end
  
  def test_dealt_card_should_not_be_included_in_playable_cards
    card = @deck.deal_card
    assert(!@deck.playable_cards.include?(card))
  end

  def test_shuffled_deck_has_52_playable_cards
    @deck.shuffle
    assert_equal @deck.playable_cards.size, 52
  end
end

class BlackjackTest < Test::Unit::TestCase
  def setup
    @blackjack = Blackjack.new
  end

  def test_new_blackjack_game_player_initialized
    assert(@blackjack.player)
  end
end
