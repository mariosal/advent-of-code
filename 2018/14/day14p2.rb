recipy = File.read('input14.txt').strip.chars.map(&:to_i)

scoreboard = [3, 7]
size = 2

sliders = [[], []]

elves = [0, 1]
building = true
offset = 0
while true
  if building
    if scoreboard.size == recipy.size
      building = false
      sliders[0] = scoreboard.clone
      sliders[1] = scoreboard.clone
    elsif scoreboard.size == recipy.size + 1
      building = false
      sliders[0] = scoreboard[-recipy.size - 1, recipy.size]
      sliders[1] = scoreboard[-recipy.size, recipy.size]
    end
  end

  if sliders[1] == recipy
    break
  elsif sliders[0] == recipy
    offset = -1
    break
  end

  sum = scoreboard.values_at(*elves).reduce(:+)
  digits = sum.to_s.chars.map(&:to_i)

  scoreboard[size] = digits[0]
  scoreboard[size + 1] = digits[1] if digits.size == 2
  size += digits.size

  sliders[0] = sliders[1].clone
  sliders[0].shift
  sliders[0] << digits[0]

  if digits.size == 2
    sliders[1].shift(2)
    sliders[1] << digits[0]
    sliders[1] << digits[1]
  else
    sliders[1] = sliders[0].clone
  end

  elves.map! do |elf|
    (elf + 1 + scoreboard[elf]) % size
  end
end

p size - recipy.size + offset
