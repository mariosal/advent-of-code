def react(polymer)
  polymer.reduce([]) do |acc, unit|
    if opposite_polarity?(acc.last, unit)
      acc.pop
    else
      acc.push(unit)
    end

    acc
  end
end

def opposite_polarity?(unit1, unit2)
  return false if [unit1, unit2].map(&:class) != [String, String]

  unit1.casecmp(unit2) == 0 && unit1 != unit2
end

polymer = File.read('input05.txt').strip.chars
puts react(polymer).size

min_size = polymer.size
('A'..'Z').each do |letter|
  filtered = polymer.reject { |unit| letter.casecmp(unit) == 0 }
  min_size = [min_size, react(filtered).size].min
end
puts min_size
