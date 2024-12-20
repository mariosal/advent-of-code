# frozen_string_literal: true

DY = [-1, 0, 1, 0].freeze
DX = [0, 1, 0, -1].freeze

def find(grid, char)
  (0...grid.size).each do |y|
    (0...grid[y].size).each do |x|
      return [y, x] if grid[y][x] == char
    end
  end
end

def shortest_path(grid, start)
  dist = {}
  dist[start] = 0

  q = Queue.new
  q << start

  until q.empty?
    pos = q.pop

    (0...4).each do |i|
      new_y = pos[0] + DY[i]
      new_x = pos[1] + DX[i]

      next if new_y < 0 || new_y >= grid.size || new_x <= 0 || new_x >= grid[new_y].size
      next if grid[new_y][new_x] == '#'
      next if dist.key?([new_y, new_x])

      dist[[new_y, new_x]] = dist[pos] + 1
      q << [new_y, new_x]
    end
  end

  dist
end

def cheat_endings(grid, start, seconds)
  output = []

  (-seconds..seconds).each do |dy|
    (-seconds..seconds).each do |dx|
      dist = dy.abs + dx.abs
      next if dist > seconds

      new_y = start[0] + dy
      new_x = start[1] + dx
      next if new_y < 0 || new_y >= grid.size || new_x < 0 || new_x >= grid[new_y].size
      next if grid[new_y][new_x] == '#'

      output << [[new_y, new_x], dist]
    end
  end

  output
end

def cheat(grid, optimal, forward, backward, seconds)
  (0...grid.size).sum do |y|
    (0...grid[y].size).sum do |x|
      cheat_start = [y, x]
      next 0 if grid[y][x] == '#'

      cheat_endings(grid, cheat_start, seconds).count do |cheat_ending, dist|
        cost = forward[cheat_start] + dist + backward[cheat_ending]
        diff = optimal - cost

        diff >= 100
      end
    end
  end
end

def solution
  grid = File.read('input20.txt').split("\n").map(&:chars)

  start = find(grid, 'S')
  ending = find(grid, 'E')
  grid[start[0]][start[1]] = '.'
  grid[ending[0]][ending[1]] = '.'

  forward = shortest_path(grid, start)
  backward = shortest_path(grid, ending)
  optimal = forward[ending]

  pp cheat(grid, optimal, forward, backward, 2)
  pp cheat(grid, optimal, forward, backward, 20)
end

solution
