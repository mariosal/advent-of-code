# frozen_string_literal: true

def end_positions(grid)
  (0...grid.size).each do |y|
    (0...grid[y].size).each do |x|
      yield [y, x] if grid[y][x] == 9
    end
  end
end

DY = [-1, 0, 1, 0].freeze
DX = [0, 1, 0, -1].freeze

def dfs(grid, trailheads, y, x)
  stack = [[y, x]]
  visited = Set.new([y, x])
  while !stack.empty?
    y, x = stack.pop

    trailheads[[y, x]] += 1

    (0...4).each do |i|
      new_y = y + DY[i]
      new_x = x + DX[i]

      next if new_y < 0 || new_y >= grid.size || new_x < 0 || new_x >= grid[new_y].size

      # next if visited.include?([new_y, new_x]) # Part 1

      next if grid[y][x] - grid[new_y][new_x] != 1

      stack << [new_y, new_x]
      visited << [new_y, new_x]
    end
  end
end

def solution
  grid = File.read('input10.txt').split("\n").map { |line| line.chars.map(&:to_i) }

  trailheads = Hash.new { |h, k| h[k] = 0 }
  end_positions(grid) do |y, x|
    dfs(grid, trailheads, y, x)
  end

  count = 0
  (0...grid.size).each do |y|
    (0...grid[y].size).each do |x|
      count += trailheads[[y, x]] if grid[y][x] == 0
    end
  end
  count
end

pp solution
