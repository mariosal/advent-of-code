min_recipies = File.read('input14.txt').to_i

scoreboard = Array.new(min_recipies + 10 + 1)
scoreboard[0] = 3
scoreboard[1] = 7
size = 2

elves = [0, 1]
while size < min_recipies + 10
  sum = scoreboard.values_at(*elves).reduce(:+)
  digits = sum.to_s.chars.map(&:to_i)

  scoreboard[size] = digits[0]
  scoreboard[size + 1] = digits[1] if digits.size == 2
  size += digits.size

  elves.map! do |elf|
    (elf + 1 + scoreboard[elf]) % size
  end
end

puts scoreboard[min_recipies, 10].join
