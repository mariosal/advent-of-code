# frozen_string_literal: true

DY = [-1, 0, 1, 0].freeze
DX = [0, 1, 0, -1].freeze

NUMERIC_KEYPAD = [
  %w[7 8 9],
  %w[4 5 6],
  %w[1 2 3],
  ['', '0', 'A']
].freeze

DIRECTIONAL_KEYPAD = [
  ['', '^', 'A'],
  ['<', 'v', '>']
].freeze

class Robot
  def initialize
    precompute_shortest_paths
  end

  def dfs(code, depth, memo = {})
    return code.size if depth == -1

    cache_key = "#{code}/#{depth}"

    return memo[cache_key] if memo.key?(cache_key)

    memo[cache_key] = "A#{code}".each_char.each_cons(2).sum do |a, b|
      @paths[a][b].reduce(Float::INFINITY) do |min, path|
        [min, dfs(path, depth - 1, memo)].min
      end
    end
  end

  def precompute_shortest_paths
    @paths = Hash.new { |h, k| h[k] = {} }

    [NUMERIC_KEYPAD, DIRECTIONAL_KEYPAD].each do |keypad|
      keys = keypad.each_with_index.flat_map do |row, y|
        row.each_with_index.map do |key, x|
          next nil if key == ''

          [key, [y, x]]
        end
      end.compact

      keys.each do |a, source|
        keys.each do |b, target|
          @paths[a][b] = shortest_paths(keypad, source, target)
        end
      end
    end
  end

  def shortest_paths(keypad, source, target, path = +'')
    return ["#{path}A"] if source == target

    paths = []

    4.times do |i|
      ny = source[0] + DY[i]
      nx = source[1] + DX[i]

      next if ny < 0 || ny >= keypad.size || nx < 0 || nx >= keypad[ny].size
      next if keypad[ny][nx] == ''

      npos = [ny, nx]

      next if 1 + distance(npos, target) != distance(source, target)

      path << direction(source, npos)
      paths.concat(shortest_paths(keypad, npos, target, path))
      path.chop!
    end

    paths
  end

  def distance(a, b)
    ay, ax = a
    by, bx = b

    (ay - by).abs + (ax - bx).abs
  end

  def direction(a, b)
    ay, ax = a
    by, bx = b

    if ay < by
      'v'
    elsif ay > by
      '^'
    elsif ax < bx
      '>'
    else
      '<'
    end
  end
end

def solution
  codes = File.read('input21.txt').split("\n")

  robot = Robot.new

  sol1 = codes.sum do |code|
    code.to_i * robot.dfs(code, 2)
  end
  pp sol1

  sol2 = codes.sum do |code|
    code.to_i * robot.dfs(code, 25)
  end
  pp sol2
end

solution
