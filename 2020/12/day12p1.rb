DIR = {
  'E' => [1, 0],
  'N' => [0, 1],
  'W' => [-1, 0],
  'S' => [0, -1]
}

DEG = {
  0 => 'E',
  90 => 'N',
  180 => 'W',
  270 => 'S'
}

def move(x, y, deg, val)
  (dx, dy) = DIR[deg]

  x += dx * val
  y += dy * val

  [x, y]
end

instructions = File.read('input12.txt').split("\n").map { |seq|
  [seq[0], seq[1..-1].to_i]
}

x = y = deg = 0

instructions.each { |action, val|
  if DIR.key?(action)
    (x, y) = move(x, y, action, val)
  end

  case action
  when 'L'
    deg = (deg + val) % 360
  when 'R'
    deg = (deg - val) % 360
  when 'F'
    (x, y) = move(x, y, DEG[deg], val)
  end
}

puts x.abs + y.abs
