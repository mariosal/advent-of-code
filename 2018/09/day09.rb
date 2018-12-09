class Node
  attr_reader :value
  attr_accessor :prev, :next

  def initialize(value)
    @value = value
    @prev = nil
    @next = nil
  end
end

class List
  def initialize
    @head = nil
    @current = nil
  end

  def insert(value)
    node = Node.new(value)

    if empty?
      node.prev = node
      node.next = node
      self.head = node
    else
      node.prev = current.next
      node.next = current.next.next
      current.next.next.prev = node
      current.next.next = node
    end

    self.current = node
  end

  def delete
    seven_prev = at(-7)
    seven_prev.prev.next = seven_prev.next
    seven_prev.next.prev = seven_prev.prev
    self.current = seven_prev.next

    seven_prev.value
  end

  private

  attr_accessor :head, :current

  def empty?
    head.nil?
  end

  def at(offset)
    at_node = current

    offset.abs.times do
      at_node =
        if offset < 0
          at_node.prev
        else
          at_node.next
        end
    end

    at_node
  end
end

class Game
  def initialize(scores, num_marbles)
    @scores = scores
    @num_marbles = num_marbles

    @table = List.new
    @table.insert(0)

    @current_player = 0
  end

  def play
    (1..num_marbles).each do |next_marble|
      if next_marble % 23 == 0
        scores[current_player] += next_marble
        scores[current_player] += table.delete
      else
        table.insert(next_marble)
      end

      self.current_player = (current_player + 1) % scores.size
    end
  end

  private

  attr_reader :num_marbles, :scores, :table
  attr_accessor :current_player
end

(num_players, num_marbles) = File.read('input09.txt').scan(/\d+/).map(&:to_i)
2.times do
  scores = Array.new(num_players, 0)

  game = Game.new(scores, num_marbles)
  game.play

  puts scores.max

  num_marbles *= 100
end
