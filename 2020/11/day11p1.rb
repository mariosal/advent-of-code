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
  numCols = layout.first.size
  numRows = layout.size
  occupied = (0..7).count { |k|
    next if i + di[k] < 0 || numRows <= i + di[k] || j + dj[k] < 0 || numCols <= j + dj[k]

    layout[i + di[k]][j + dj[k]] == '#'
  }

  if layout[i][j] == 'L' && occupied == 0
    '#'
  elsif layout[i][j] == '#' && occupied >= 4
    'L'
  else
    layout[i][j]
  end
end

while true
  (layout, changed) = tick(layout)

  if !changed
    puts layout.sum { |row| row.count { |seat| seat == '#' } }

    break
  end
end
