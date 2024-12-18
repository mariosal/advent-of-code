# frozen_string_literal: true

SIZE = 71
DY = [-1, 0, 1, 0].freeze
DX = [0, 1, 0, -1].freeze

class State
  attr_reader :pos, :cost

  def initialize(pos, cost)
    @pos = pos
    @cost = cost
  end
end

def bfs(grid, start, ending)
  q = Queue.new
  q << State.new(start, 0)
  visited = Set.new
  visited << start

  until q.empty?
    state = q.pop

    return state.cost if state.pos == ending

    (0...4).each do |i|
      new_y = state.pos[0] + DY[i]
      new_x = state.pos[1] + DX[i]

      next if new_y < 0 || new_y >= grid.size || new_x < 0 || new_x >= grid[new_y].size
      next if grid[new_y][new_x] == '#'
      next if visited.include?([new_y, new_x])

      visited << [new_y, new_x]

      q << State.new([new_y, new_x], state.cost + 1)
    end
  end

  nil
end

def solution
  walls = File.read('input18.txt').split("\n").map { |line| line.split(',').map(&:to_i) }

  grid = Array.new(SIZE) { Array.new(SIZE, '.') }

  walls.each_with_index do |(x, y), index|
    break if index == 1024

    grid[y][x] = '#'
  end
  pp bfs(grid, [0, 0], [SIZE - 1, SIZE - 1])

  sol2 = walls.find do |x, y|
    grid[y][x] = '#'

    bfs(grid, [0, 0], [SIZE - 1, SIZE - 1]).nil?
  end
  pp sol2
end

solution
