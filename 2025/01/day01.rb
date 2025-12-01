# frozen_string_literal: true

def solution
  input = File.read('input01.txt').split("\n").map { |line| [line[0] == 'R' ? 1 : -1, line[1..].to_i] }

  pp part1(input)
  pp part2(input)
end

def part1(input)
  point = 50

  input.count do |direction, distance|
    point = (point + (direction * distance)) % 100

    point == 0
  end
end

def part2(input)
  point = 50

  input.sum do |direction, distance|
    (0...distance).count do
      point = (point + direction) % 100

      point == 0
    end
  end
end

solution
