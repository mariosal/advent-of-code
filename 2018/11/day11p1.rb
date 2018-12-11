class Fuel
  attr_reader :x, :y, :serial_number

  def initialize(x, y, serial_number)
    @x = x
    @y = y
    @serial_number = serial_number
  end

  def power_level
    @power_level ||= ((rack_id * y + serial_number) * rack_id) / 100 % 10 - 5
  end

  private

  def rack_id
    x + 10
  end
end

class Grid
  attr_reader :width, :height, :serial_number

  def initialize(width, height, serial_number)
    @width = width
    @height = height
    @serial_number = serial_number
  end

  def total_power
    max_coord = [1, 1]
    max_power = power(0, 0, 2)

    size = 2
    (0...(height - size)).each do |y|
      (0...(width - size)).each do |x|
        cur_power = power(x, y, 2)
        if max_power < cur_power
          max_power = cur_power
          max_coord = [x + 1, y + 1]
        end
      end
    end

    max_coord.join(',')
  end

  private

  def sum
    return @sum if defined?(@sum)

    @sum = Array.new(height) do
      Array.new(width)
    end

    (0...height).each do |y|
      (0...width).each do |x|
        top_sum = y > 0 ? @sum[y - 1][x] : 0
        left_sum = x > 0 ? @sum[y][x - 1] : 0
        top_left_sum = y > 0 && x > 0 ? @sum[y - 1][x - 1] : 0

        @sum[y][x] = grid[y][x].power_level +
                     top_left_sum +
                     left_sum - top_left_sum +
                     top_sum - top_left_sum
      end
    end

    @sum
  end

  def power(x, y, size)
    ret = sum[y + size][x + size]
    ret -= sum[y - 1][x + size] if y > 0
    ret -= sum[y + size][x - 1] if x > 0
    ret += sum[y - 1][x - 1] if y > 0 && x > 0
    ret
  end

  def grid
    @grid ||= Array.new(height) do |y|
      Array.new(width) do |x|
        Fuel.new(x + 1, y + 1, serial_number)
      end
    end
  end
end

serial_number = File.read('input11.txt').to_i

grid = Grid.new(300, 300, serial_number)
puts grid.total_power
