layout = File.read('input11.txt').split("\n").map(&:chars)

def tick(layout)
  new_layout = Array.new(layout.size) { Array.new(layout.first.size) }
  changed = false

  (0...layout.size).each { |i|
    (0...layout[i].size).each { |j|
      new_layout[i][j] = mut(layout, i, j)

      changed ||= new_layout[i][j] != layout[i][j]
    }
  }

  [new_layout, changed]
end

def mut(layout, i, j)
  return '.' if layout[i][j] == '.'

  di = [-1, -1, -1, 0, 1, 1,  1,  0]
  dj = [-1,  0,  1, 1, 1, 0, -1, -1]
  occupied = (0..7).count { |k|
    nearest_seat(layout, i, j, di[k], dj[k]) == '#'
  }

  if layout[i][j] == 'L' && occupied == 0
    '#'
  elsif layout[i][j] == '#' && occupied >= 5
    'L'
  else
    layout[i][j]
  end
end

def nearest_seat(layout, i, j, di, dj)
  factor = 1
  while valid?(layout, i + di * factor, j + dj * factor)
    seat = layout[i + di * factor][j + dj * factor]
    return seat if seat != '.'

    factor += 1
  end
end

def valid?(layout, i, j)
  numRows = layout.size
  numCols = layout.first.size

  0 <= i && i < numRows && 0 <= j && j <= numCols
end

while true
  (layout, changed) = tick(layout)

  if !changed
    puts layout.sum { |row| row.count { |seat| seat == '#' } }

    break
  end
end
