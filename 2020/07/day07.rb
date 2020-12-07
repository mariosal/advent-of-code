def color(string)
  split = string.split(' ')

  if string[0].match?(/[0-9]/)
    [split[1..-2].join(' '), split[0].to_i]
  elsif split[0] == 'no'
    nil
  else
    split[0..-2].join(' ')
  end
end

def contains?(rules, bag, color)
  rules[bag].keys.any? { |inner_bag|
    inner_bag == color || contains?(rules, inner_bag, color)
  }
end

def presence(rules, color)
  rules.keys.count { |bag|
    bag != color && contains?(rules, bag, color)
  }
end

def inner_bags(rules, color)
  counts = rules[color].map { |inner_bag, count|
    count + count * inner_bags(rules, inner_bag)
  }.sum
end

rules = File.read('input07.txt').split("\n")

rules = rules.map { |rule|
  (key, values) = rule.split(' contain ')

  [color(key), values.split(', ').map { |v| color(v) }.compact.to_h]
}.to_h

puts presence(rules, 'shiny gold')
puts inner_bags(rules, 'shiny gold')
