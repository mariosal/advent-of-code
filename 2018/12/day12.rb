require 'set'

def print_state(state)
  (left_most, right_most) = state.keys.minmax
  (left_most..right_most).reduce('') do |acc, i|
    acc << state[i]
  end
end

def tick(state, rules)
  next_state = Hash.new { '.' }

  state.each_key do |i|
    6.times do |j|
      window = state.values_at(*((i - j)..(i - j + 4))).join
      next_state[i - j + 2] = rules[window] if rules.key?(window)
    end
  end

  next_state
end

def sum(state, rules, limit)
  memo = Set.new
  stable_step = 0
  loop do
    break if stable_step >= limit

    str = print_state(state)
    break if memo.include?(str)

    memo << str
    state = tick(state, rules)
    stable_step += 1
  end

  sum = state.reduce(0) do |acc, (k, v)|
    acc += k if v == '#'
    acc
  end
  sum += state.keys.size * (limit - stable_step) if limit > stable_step

  sum
end

input = File.read('input12.txt').split("\n")

initial = input.shift.split(': ')[1].chars.each.with_index
               .reduce(Hash.new { '.' }) do |acc, (char, index)|
  acc[index] = char
  acc
end
input.shift

rules = input.reduce({}) do |acc, rule|
  (lhs, rhs) = rule.split(' => ')
  acc[lhs] = rhs if rhs == '#'
  acc
end

puts sum(initial, rules, 20)
puts sum(initial, rules, 50000000000)
