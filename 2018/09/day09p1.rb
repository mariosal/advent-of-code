class Game
  def initialize(scores, num_marbles)
    @scores = scores
    @num_marbles = num_marbles

    @table = [0]
    @current_index = 0
    @current_player = 0
  end

  def play
    (1..num_marbles).each do |next_marble|
      if next_marble % 23 == 0
        scores[current_player] += next_marble

        seven_index = (current_index - 7) % table.size
        scores[current_player] += table.delete_at(seven_index)

        self.current_index = seven_index % table.size
      else
        tmp_next_index = next_index
        table.insert(next_index, next_marble)
        self.current_index = tmp_next_index
      end

      self.current_player = (current_player + 1) % scores.size
    end
  end

  private

  attr_reader :num_marbles, :scores, :table
  attr_accessor :current_index, :current_player

  def next_index
    if (current_index + 2) % table.size == 0
      table.size
    else
      (current_index + 2) % table.size
    end
  end
end

(num_players, num_marbles) = File.read('input09.txt').scan(/\d+/).map(&:to_i)
scores = Array.new(num_players, 0)

game = Game.new(scores, num_marbles)
game.play

puts scores.max
