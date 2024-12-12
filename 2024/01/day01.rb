# frozen_string_literal: true

def solution
  input = File.read('input01.txt').split("\n").map { |line| line.split.map(&:to_i) }.transpose.map(&:sort)

  sol1 = input.transpose.sum do |a, b|
    (b - a).abs
  end
  pp sol1

  left, right = input
  freq = right.tally
  left.sum do |number|
    number * freq.fetch(number, 0)
  end
end

pp solution
