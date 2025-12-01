# frozen_string_literal: true

def convert_to_heights(schematic)
  (0...schematic[0].size).map do |x|
    (0...schematic.size).count do |y|
      schematic[y][x] == '#'
    end - 1
  end
end

def unlocks?(key, lock)
  key.zip(lock).all? { |k, l| k + 1 + l + 1 <= 7 }
end

def solution
  schematics = File.read('input25.txt').split("\n\n").map do |schematic|
    schematic.split("\n")
  end

  locks = []
  keys = []
  schematics.each do |schematic|
    heights = convert_to_heights(schematic)

    if schematic[0].include?('#')
      locks << heights
    else
      keys << heights
    end
  end

  sum = 0
  keys.each do |key|
    locks.each do |lock|
      sum += 1 if unlocks?(key, lock)
    end
  end

  pp sum
end

solution
