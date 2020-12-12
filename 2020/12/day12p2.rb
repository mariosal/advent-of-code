require 'matrix'
include Math

DIRECTIONS = {
  'E' => Vector[1, 0],
  'N' => Vector[0, 1],
  'W' => Vector[-1, 0],
  'S' => Vector[0, -1]
}

def rotate(degrees)
  radians = degrees * PI / 180

  Matrix[
    [cos(radians), -sin(radians)],
    [sin(radians), cos(radians)]
  ]
end

instructions = File.read('input12.txt').split("\n").map { |sequence|
  [sequence[0], sequence[1..-1].to_i]
}

ship = Vector[0, 0]
waypoint = Vector[10, 1]

instructions.each { |action, value|
  case action
  when *DIRECTIONS.keys
    waypoint += value * DIRECTIONS[action]
  when 'L'
    waypoint = rotate(value) * waypoint
  when 'R'
    waypoint = rotate(-value) * waypoint
  when 'F'
    ship += value * waypoint
  end
}

puts ship.map(&:abs).sum
