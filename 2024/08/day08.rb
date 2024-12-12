# frozen_string_literal: true

EMPTY = '.'

class Grid
  def initialize(map)
    @map = map
    @antennas = Hash.new { |h, k| h[k] = [] }

    (0...map.size).each do |y|
      (0...map[y].size).each do |x|
        next if map[y][x] == EMPTY

        @antennas[map[y][x]] << [y, x]
      end
    end
  end

  def same_line?(y, x, yy, xx, yyy, xxx)
    (xx - x) * (yyy - y) == (yy - y) * (xxx - x)
  end

  def distance(y, x, yy, xx)
    # Part 1
    # (yy - y).abs + (xx - x).abs

    # Part 2
    0
  end

  def antinodes
    count = 0

    (0...@map.size).each do |y|
      (0...@map[y].size).each do |x|
        found = false

        @antennas.each_value do |positions|
          positions.combination(2) do |(yy, xx), (yyy, xxx)|
            if same_line?(y, x, yy, xx, yyy, xxx) &&
               (distance(y, x, yy, xx) == 2 * distance(y, x, yyy, xxx) ||
                  2 * distance(y, x, yy, xx) == distance(y, x, yyy, xxx))
              found = true
              break
            end
          end

          break if found
        end

        count += 1 if found
      end
    end

    count
  end
end

def solution
  map = File.read('input08.txt').split("\n").map(&:chars)
  grid = Grid.new(map)

  grid.antinodes
end

pp solution
