class Vector
  attr_accessor :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def +(other)
    Vector.new(x + other.x, y + other.y)
  end
end

class Point
  attr_reader :position, :velocity

  def initialize(position_x, position_y, velocity_x, velocity_y)
    @position = Vector.new(position_x, position_y)
    @velocity = Vector.new(velocity_x, velocity_y)
  end

  def tick(time)
    new_position_x = position.x + velocity.x * time
    new_position_y = position.y + velocity.y * time
    Point.new(new_position_x, new_position_y, velocity.x, velocity.y)
  end
end

class Grid
  attr_reader :points
  attr_accessor :positions

  def initialize(points)
    @points = points
  end

  def size(time)
    self.positions = points.map do |point|
      point.tick(time).position
    end

    (right - left + 1) * (bottom - top + 1)
  end

  def tick(time)
    self.positions = points.map do |point|
      point.tick(time).position
    end

    grid = Array.new(right - left + 1) do
      Array.new(bottom - top + 1, '.')
    end

    positions.each do |position|
      grid[position.x - left][position.y - top] = '#'
    end

    (0...grid.first.size).each do |y|
      (0...grid.size).each do |x|
        print grid[x][y]
      end
      print "\n"
    end
  end

  private

  def top
    positions.map(&:y).min
  end

  def right
    positions.map(&:x).max
  end

  def bottom
    positions.map(&:y).max
  end

  def left
    positions.map(&:x).min
  end
end

points = File.read('input10.txt').split("\n").map do |point|
  Point.new(*point.scan(/-?\d+/).map(&:to_i))
end

grid = Grid.new(points)
time = 0
while grid.size(time) > grid.size(time + 1)
  time += 1
end

puts time
grid.tick(time)
