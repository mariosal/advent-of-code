# frozen_string_literal: true

DY = [-1, 0, 1, 0].freeze
DX = [0, 1, 0, -1].freeze

MOVE = {
  '^' => 0,
  '>' => 1,
  'v' => 2,
  '<' => 3
}.freeze

def fish_pos(grid)
  (0...grid.size).each do |y|
    (0...grid[y].size).each do |x|
      return [y, x] if grid[y][x] == '@'
    end
  end
end

def pushable?(grid, y, x, dir, visited = Set.new)
  return true if visited.include?([y, x])
  return true if grid[y][x] == '.'
  return false if grid[y][x] == '#'

  visited << [y, x]

  new_y = y + DY[dir]
  new_x = x + DX[dir]
  if grid[y][x] == '['
    pushable?(grid, y, x + 1, dir, visited) && pushable?(grid, new_y, new_x, dir, visited)
  elsif grid[y][x] == ']'
    pushable?(grid, y, x - 1, dir, visited) && pushable?(grid, new_y, new_x, dir, visited)
  end
end

def push(grid, y, x, dir, visited = Set.new)
  return if visited.include?([y, x])

  visited << [y, x]

  if grid[y][x] == '['
    push(grid, y, x + 1, dir, visited)
  elsif grid[y][x] == ']'
    push(grid, y, x - 1, dir, visited)
  end

  new_y = y + DY[dir]
  new_x = x + DX[dir]

  push(grid, new_y, new_x, dir, visited) if grid[new_y][new_x] == '[' || grid[new_y][new_x] == ']'

  grid[new_y][new_x] = grid[y][x]
  grid[y][x] = '.'
end

def solution
  grid, moves = File.read('input15.txt').split("\n\n")

  grid = grid.split("\n").map do |line|
    line.chars.flat_map do |cell|
      case cell
      when '.'
        ['.', '.']
      when '#'
        ['#', '#']
      when 'O'
        ['[', ']']
      when '@'
        ['@', '.']
      end
    end
  end

  moves = moves.split("\n").join.chars

  y, x = fish_pos(grid)
  grid[y][x] = '.'

  moves.each do |move|
    dir = MOVE[move]

    new_y = y + DY[dir]
    new_x = x + DX[dir]

    if grid[new_y][new_x] == '.'
      y = new_y
      x = new_x
    elsif (grid[new_y][new_x] == '[' || grid[new_y][new_x] == ']') && pushable?(grid, new_y, new_x, dir)
      push(grid, new_y, new_x, dir)

      y = new_y
      x = new_x
    end
  end

  count = 0
  (0...grid.size).each do |y|
    (0...grid[y].size).each do |x|
      count += (y * 100) + x if grid[y][x] == '['
    end
  end
  pp count
end

solution
