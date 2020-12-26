class Carta
  def initialize(suit, symbol)
    @naipe = suit
    @simbolo = symbol
  end

  def show
    hsh = {1 => 'As', 2 => '2', 3 => '3', 4 => '4', 5 => '5', 6 => '6', 7 => '7', 8 => '8', 9 => '9', 10 => '10', 11 => 'Valete', 12 => 'Dama', 13 => 'Rei'}
    {hsh[@simbolo] => @naipe}
  end

  attr_reader :naipe
  attr_reader :simbolo
end

class Baralho
  def initialize(cards = [])
    @cartas = cards
  end

  def add_card(simbolo, naipe)
    new_card = Carta.new(naipe, simbolo)
    @cartas.append({:symbol => new_card.simbolo, :suit => new_card.naipe})
  end

  def sort
    @cartas.sort_by!(&:symbol)
  end

  def shuffle
    @cartas.shuffle!
  end

  def human_index
    @cartas.each do |card|
      show_card = Carta.new(card[:symbol], card[:suit])
      show_card.show
    end
  end

  def size
    @cartas.length
  end

  def pull
    random = @cartas.sample
    @cartas.delete(random)
    random
  end
end

class Jogo_de_Poker
  @@count = 0
  @@deck = Baralho.new()

  def initialize(table_cards = [], bet = 0, stage = 0, players = [])
    @table_cards = table_cards
    @bet = bet
    @stage = stage
    @players = players
    @@count
  end

  def add_player(name)
    cards = []
    if (@stage == 0) and (@@deck.size >= 2)
      cards.append(@@deck.pull) * 2
      @players.append({:id => @@count, :nome => name, :dinheiro => 1000, :cartas => cards, :no_jogo => true})
      @@count += 1
    end
  end

  def progress_stage
    if @stage == 0
      @stage += 1
    elsif @stage == 1
      @table_cards.append(@@deck.pull) * 5
      i = 0
      while i < 3 do
        @table_cards[i].human_index
      end
      @stage += 1
    elsif @stage == 2
      @table_cards[3].human_index
      @stage += 1
    elsif @stage == 3
      @table_cards[4].human_index
      @stage = 0
    end
  end

  def raise_bet(money, id)
    in_game = []
    @players.each do |jogador|
      if jogador[:no_jogo]
        if jogador[:id] == id
          jogador[:dinheiro] -= money
          @bet += money
        else
          in_game.append(jogador)
        end
      end
    end
    in_game.each do |i|
      puts "Você quer cobrir a aposta, #{i[:nome]}? (s, n)"
      j = gets
      if j == 's'
        if i[:dinheiro] >= money
          i[:dinheiro] -= money
          @bet += money
        else
          @bet += i[:dinheiro]
          i[:dinheiro] = 0
        end
      elsif j == 'n'
        i[:no_jogo] = false
      end
    end
  end

  def show_cards
    if @stage == 1
      mostrar = @table_cards.take(3)
      mostrar.each do |i|
        i.human_index
      end
    elsif @stage == 2
      mostrar = @table_cards.take(4)
      mostrar.each do |i|
        i.human_index
      end
    elsif @stage == 3
      @table_cards.each do |i|
        i.human_index
      end
    end
  end

  def winner(id)
    @players.each do |jogador|
      if jogador[:id] == id
        jogador[:dinheiro] += @bet
      end
      jogador[:no_jogo] = true
    end
    @bet = 0
    @table_cards = []
  end

  attr_reader :players
  attr_reader :bet
  attr_reader :stage
end