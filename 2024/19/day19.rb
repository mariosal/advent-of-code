# frozen_string_literal: true

def possible?(patterns, design, i = 0, memo = {})
  return memo[i] if memo.key?(i)
  return memo[i] = true if i == design.size

  memo[i] = (i...design.size).any? do |j|
    substr = design[i..j]

    next false if !patterns.include?(substr)

    possible?(patterns, design, j + 1, memo)
  end
end

def ways(patterns, design, i = 0, memo = {})
  return memo[i] if memo.key?(i)
  return memo[i] = 1 if i == design.size

  memo[i] = (i...design.size).sum do |j|
    substr = design[i..j]

    next 0 if !patterns.include?(substr)

    ways(patterns, design, j + 1, memo)
  end
end

def solution
  patterns, designs = File.read('input19.txt').split("\n\n")

  patterns = patterns.split(', ').to_set
  designs = designs.split("\n")

  sol1 = designs.count do |design|
    possible?(patterns, design)
  end
  pp sol1

  sol2 = designs.sum do |design|
    ways(patterns, design)
  end
  pp sol2
end

solution
