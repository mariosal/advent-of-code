# frozen_string_literal: true

require 'pqueue'

DY = [-1, 0, 1, 0].freeze
DX = [0, 1, 0, -1].freeze

class State
  attr_reader :pos, :tokens, :dir, :path

  def initialize(pos, tokens, dir, path)
    @pos = pos
    @dir = dir
    @tokens = tokens
    @path = path
  end

  def <=>(other)
    if tokens == other.tokens
      return dir <=> other.dir if pos == other.pos

      return pos <=> other.pos
    end

    -1 * (tokens <=> other.tokens)
  end
end

def find(grid, char)
  (0...grid.size).each do |y|
    (0...grid[y].size).each do |x|
      return [y, x] if grid[y][x] == char
    end
  end
end

def bfs(grid, start, ending)
  q = PQueue.new
  q << State.new(start, 0, 1, [start].to_set)
  visited = Hash.new(Float::INFINITY)
  visited[[start, 1]] = 0
  min_cost = Float::INFINITY
  paths = Set.new
  until q.empty?
    state = q.pop

    if state.pos == ending
      if min_cost == Float::INFINITY
        paths = state.path
        min_cost = state.tokens
      elsif min_cost == state.tokens
        paths += state.path
      end

      next
    end

    new_pos = []
    new_pos << (state.pos[0] + DY[state.dir])
    new_pos << (state.pos[1] + DX[state.dir])

    [[new_pos, state.dir], [state.pos, state.dir - 1], [state.pos, state.dir + 1]].each do |new_pos, new_dir|
      next if grid[new_pos[0]][new_pos[1]] == '#'

      new_dir %= 4
      cost = if new_dir == state.dir
               1
             else
               1000
             end

      next if visited[[new_pos, new_dir]] < state.tokens + cost

      visited[[new_pos, new_dir]] = state.tokens + cost
      q << State.new(new_pos, state.tokens + cost, new_dir, state.path + [new_pos])
    end
  end

  [min_cost, paths.size]
end

def solution
  grid = File.read('input16.txt').split("\n").map(&:chars)

  start = find(grid, 'S')
  ending = find(grid, 'E')
  grid[start[0]][start[1]] = '.'
  grid[ending[0]][ending[1]] = '.'

  pp bfs(grid, start, ending)
end

solution
