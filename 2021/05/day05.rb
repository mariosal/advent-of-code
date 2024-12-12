# frozen_string_literal: true

input = File.read('input05.txt').split("\n").map do |line|
  (left, right) = line.split(' -> ')

  [left, right].map do |coord|
    coord.split(',').map(&:to_i)
  end
end

grid = Hash.new { |h, k| h[k] = Hash.new(0) }

def horizontal?(left, right)
  left[1] == right[1]
end

def vertical?(left, right)
  left[0] == right[0]
end

def to_right?(left, right)
  left[0] <= right[0]
end

input.each do |left, right|
  if horizontal?(left, right)
    ([left[0], right[0]].min..[left[0], right[0]].max).each do |i|
      grid[left[1]][i] += 1
    end
  elsif vertical?(left, right)
    ([left[1], right[1]].min..[left[1], right[1]].max).each do |i|
      grid[i][left[0]] += 1
    end
  else # PART 2
    (left, right) = [left.reverse, right.reverse].sort.map(&:reverse)

    i = 0
    if to_right?(left, right)
      loop do
        grid[left[1] + i][left[0] + i] += 1
        break if left[1] + i == right[1]

        i += 1
      end
    else
      loop do
        grid[left[1] + i][left[0] - i] += 1
        break if left[1] + i == right[1]

        i += 1
      end
    end
  end
end

sol = grid.sum do |_, v|
  v.count { |_, cell| cell >= 2 }
end
pp sol
