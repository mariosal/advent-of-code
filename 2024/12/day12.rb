# frozen_string_literal: true

DY = [-1, 0, 1, 0].freeze
DX = [0, 1, 0, -1].freeze

def dfs2(grid, y, x, visited, borderv, borderh)
  1 + (0...4).sum do |i|
    new_y = y + DY[i]
    new_x = x + DX[i]

    if new_y < 0 || new_y >= grid.size || new_x < 0 || new_x >= grid[y].size || grid[new_y][new_x] != grid[y][x]
      case i
      when 0 # Top
        borderh["#{new_y}T"] << new_x
      when 2 # Bottom
        borderh["#{new_y}B"] << new_x
      when 1 # Right
        borderv["#{new_x}R"] << new_y
      when 3 # Left
        borderv["#{new_x}L"] << new_y
      end

      next 0
    end

    next 0 if visited.include?([new_y, new_x])

    visited << [new_y, new_x]

    dfs2(grid, new_y, new_x, visited, borderv, borderh)
  end
end

def dfs(grid, y, x, visited)
  region = 1
  perimeter = 0

  (0...4).each do |i|
    new_y = y + DY[i]
    new_x = x + DX[i]

    if new_y < 0 || new_y >= grid.size || new_x < 0 || new_x >= grid[y].size || grid[new_y][new_x] != grid[y][x]
      perimeter += 1

      next
    end

    next if visited.include?([new_y, new_x])

    visited << [new_y, new_x]

    new_region, new_perimeter = dfs(grid, new_y, new_x, visited)

    region += new_region
    perimeter += new_perimeter
  end

  [region, perimeter]
end

def count_seq(border)
  border.sum do |_, coords|
    1 + coords.sort.each_cons(2).count do |a, b|
      b - a != 1
    end
  end
end

def solution
  grid = File.read('input12.txt').split("\n").map(&:chars)

  visited = Set.new

  (0...grid.size).sum do |y|
    (0...grid[y].size).sum do |x|
      next 0 if visited.include?([y, x])

      visited << [y, x]

      # Part 1
      # region, perimeter = dfs(grid, y, x, visited)
      # region * perimeter

      # Part 2
      borderv = Hash.new { |h, k| h[k] = Set.new }
      borderh = Hash.new { |h, k| h[k] = Set.new }

      region = dfs2(grid, y, x, visited, borderv, borderh)

      bv = count_seq(borderv)
      bh = count_seq(borderh)

      (bv + bh) * region
    end
  end
end

pp solution
