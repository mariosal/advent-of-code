# frozen_string_literal: true

require 'forwardable'

GUARD = '^'
WALL = '#'
DIRECTIONS = 4
DY = [-1, 0, 1, 0].freeze
DX = [0, 1, 0, -1].freeze

class Guard
  attr_reader :visited

  def initialize(board)
    @board = board

    (0...board.size).each do |y|
      (0...board[y].size).each do |x|
        if board[y][x] == GUARD
          @initial_y = y
          @initial_x = x
        end
      end
    end

    reset
  end

  def reset
    @dir = 0
    @y = @initial_y
    @x = @initial_x
    @visited = Set.new
  end

  def rotate
    @dir = (@dir + 1) % DIRECTIONS
  end

  def next_pos
    [@y + DY[@dir], @x + DX[@dir]]
  end

  def tick
    return false if !@board.inside?(@y, @x)

    @visited << [@y, @x]

    next_y, next_x = next_pos

    if @board.wall?(next_y, next_x)
      rotate
    else
      @y = next_y
      @x = next_x
    end

    true
  end

  # [moving, stuck_in_a_loop]
  def tick2
    return [false, false] if !@board.inside?(@y, @x)
    return [false, true] if @visited.include?([@y, @x, @dir])

    @visited << [@y, @x, @dir]

    next_y, next_x = next_pos

    if @board.wall?(next_y, next_x)
      rotate
    else
      @y = next_y
      @x = next_x
    end

    [true, false]
  end
end

class Board
  extend Forwardable

  def_delegators :@board, :size, :[]

  def initialize(board)
    @initial_board = board
    reset
  end

  def reset
    @board = @initial_board.map(&:dup)
  end

  def add_obstruction(y, x)
    @board[y][x] = WALL
  end

  def wall?(y, x)
    inside?(y, x) && @board[y][x] == WALL
  end

  def inside?(y, x)
    y >= 0 && y < @board.size && x >= 0 && x < @board[y].size
  end
end

class Lab
  attr_reader :board, :guard

  def initialize(input)
    @board = Board.new(input)
    @guard = Guard.new(@board)
  end

  def run
    while @guard.tick
    end
  end

  def run2
    loop do
      moving, stuck = @guard.tick2

      return true if stuck
      return false if !moving
    end
  end
end

def solution
  input = File.read('input06.txt').split("\n")
  lab = Lab.new(input)

  lab.run
  pp lab.guard.visited.size

  lab.guard.reset
  lab.board.reset
  lab.run2

  lab.guard.visited.map { |y, x, _| [y, x] }.uniq.count do |y, x|
    lab.guard.reset
    lab.board.reset
    lab.board.add_obstruction(y, x)

    lab.run2
  end
end

pp solution
