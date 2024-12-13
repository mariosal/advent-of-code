# frozen_string_literal: true

require 'pqueue'

class State
  attr_reader :pos, :tokens

  def initialize(pos, tokens)
    @pos = pos
    @tokens = tokens
  end

  def <=>(other)
    return pos <=> other.pos if tokens == other.tokens

    tokens <=> other.tokens
  end
end

class Button
  attr_reader :x, :y

  def initialize(input)
    matches = input.match(/X\+(?<x>\d+), Y\+(?<y>\d+)/)
    @x = matches[:x].to_i
    @y = matches[:y].to_i
  end

  def push(pos)
    [pos[0] + @x, pos[1] + @y]
  end
end

COST = [3, 1].freeze
# DELTA = 0 # PART 1
DELTA = 10000000000000 # PART 2

class Machine
  def initialize(input)
    lines = input.split("\n")
    @buttons = lines[..1].map { |button_input| Button.new(button_input) }

    matches = lines[2].match(/X=(?<x>\d+), Y=(?<y>\d+)/)
    @prize = [matches[:x].to_i + DELTA, matches[:y].to_i + DELTA]
  end

  # Button A = X1, Y1
  # Button B = X2, X2
  # Prize    = X,  Y
  #
  # a * X1 + b * X2 = X
  # a * Y1 + b * Y2 = Y
  #
  # Solve for a and b
  def tokens2
    b1 = ((@prize[1] * @buttons[0].x) - (@prize[0] * @buttons[0].y))
    b2 = ((@buttons[1].y * @buttons[0].x) - (@buttons[1].x * @buttons[0].y))
    return 0 if b1 % b2 != 0

    b = b1 / b2

    a1 = (@prize[0] - (b * @buttons[1].x))
    a2 = @buttons[0].x
    return 0 if a1 % a2 != 0

    a = a1 / a2

    (a * COST[0]) + (b * COST[1])
  end

  def tokens
    q = PQueue.new
    q << State.new([0, 0], 0)
    visited = Set.new([[0, 0]])
    until q.empty?
      state = q.pop

      return state.tokens if state.pos == @prize

      @buttons.each_with_index do |button, index|
        new_pos = button.push(state.pos)
        next if new_pos[0] > @prize[0] || new_pos[1] > @prize[1] || visited.include?(new_pos)

        visited << new_pos
        q << State.new(new_pos, state.tokens + COST[index])
      end
    end

    0
  end
end

def solution
  machines = File.read('input13.txt').split("\n\n").map do |machine_input|
    Machine.new(machine_input)
  end

  # pp machines.sum(&:tokens) # PART 1
  machines.sum(&:tokens2) # PART 2
end

pp solution
