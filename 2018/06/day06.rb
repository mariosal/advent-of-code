require 'set'

class Grid
  def initialize(coords)
    @coords = coords
    normalize_coords
  end

  def area
    return @area if defined?(@area)

    @area = Array.new(right - left + 1) do
      Array.new(bottom - top + 1) do
        Set.new
      end
    end

    coords.each.with_index do |coord, index|
      @area[coord.x][coord.y] << index
    end

    @area
  end

  def finite_area
    fill

    count = Hash.new do |hash, key|
      hash[key] = 0
    end
    (0...area.size).each do |x|
      (0...area.first.size).each do |y|
        if area[x][y].size == 1 && !(area[x][y] - infinite_coords).empty?
          count[area[x][y].first] += 1
        end
      end
    end

    count.map { |_, v| v }.max
  end

  def near_region
    near_region = 0
    (0...area.size).each do |x|
      (0...area.first.size).each do |y|
        sum = dists[x][y].reduce(:+)
        near_region += 1 if sum < 10000
      end
    end
    near_region
  end

  private

  attr_reader :coords

  def dists
    @dists ||= Array.new(area.size) do |x|
      Array.new(area.first.size) do |y|
        Array.new(coords.size) do |index|
          (x - coords[index].x).abs + (y - coords[index].y).abs
        end
      end
    end
  end

  def fill
    (0...area.size).each do |x|
      (0...area.first.size).each do |y|
        min_dist = dists[x][y].min
        area[x][y] += dists[x][y].each.with_index.select do |dist, _|
          dist == min_dist
        end.map(&:last)
      end
    end
  end

  def infinite_coords
    return @infinite_coords if defined?(@infinite_coords)

    @infinite_coords = Set.new
    (0...area.size).each do |x|
      @infinite_coords += area[x][0] if area[x][0].size == 1
      @infinite_coords += area[x][area.first.size - 1] if area[x][area.first.size - 1] == 1
    end

    (0...area.first.size).each do |y|
      @infinite_coords += area[0][y] if area[0][y].size == 1
      @infinite_coords += area[area.size - 1][y] if area[area.size - 1][y].size == 1
    end

    @infinite_coords
  end

  def normalize_coords
    # Memo before normalization
    right
    bottom

    coords.each do |coord|
      coord.x -= left
      coord.y -= top
    end
  end

  def top
    @top ||= coords.map(&:y).min
  end

  def right
    @right ||= coords.map(&:x).max
  end

  def bottom
    @bottom ||= coords.map(&:y).max
  end

  def left
    @left ||= coords.map(&:x).min
  end
end

class Point
  attr_accessor :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end
end

coords = File.read('input06.txt').split("\n").map do |coord|
  Point.new(*coord.split(', ').map(&:to_i))
end

grid = Grid.new(coords)
p grid.finite_area
p grid.near_region
