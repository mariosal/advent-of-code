# frozen_string_literal: true

WORD = 'XMAS'
DY = [-1, -1, -1, 0, 0, 1, 1, 1].freeze
DX = [-1, 0, 1, -1, 1, -1, 0, 1].freeze

def start_positions(grid)
  (0...grid.size).each do |y|
    (0...grid[y].size).each do |x|
      yield [y, x] if grid[y][x] == WORD[0]
    end
  end
end

def dfs(grid, d, y, x, k = 1)
  return true if k >= WORD.size

  new_y = y + DY[d]
  new_x = x + DX[d]

  return false if new_y < 0 || new_y >= grid.size || new_x < 0 || new_x >= grid[new_y].size

  grid[new_y][new_x] == WORD[k] && dfs(grid, d, new_y, new_x, k + 1)
end

def solution1
  grid = File.read('input04.txt').split("\n")

  count = 0
  start_positions(grid) do |y, x|
    count += (0...8).count do |d|
      dfs(grid, d, y, x)
    end
  end

  count
end

pp solution1

CROSS = [
  ['M', '.', 'S'],
  ['.', 'A', '.'],
  ['M', '.', 'S']
].freeze

def check_cross?(grid, y, x)
  return false if y >= grid.size - 2 || x >= grid[y].size - 2

  matrix = CROSS

  4.times.any? do
    matrix = matrix.transpose.map(&:reverse)

    (0...3).all? do |i|
      (0...3).all? do |j|
        matrix[i][j] == '.' || matrix[i][j] == grid[y + i][x + j]
      end
    end
  end
end

def solution2
  grid = File.read('input04.txt').split("\n")

  (0...grid.size).sum do |y|
    (0...grid[y].size).count do |x|
      check_cross?(grid, y, x)
    end
  end
end

pp solution2
