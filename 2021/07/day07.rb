# frozen_string_literal: true

crabs = File.read('input07.txt').split(',').map(&:to_i)

sol1 = (crabs.min..crabs.max).map do |pos|
  crabs.sum do |crab|
    (pos - crab).abs
  end
end.min

sol2 = (crabs.min..crabs.max).map do |pos|
  crabs.sum do |crab|
    diff = (pos - crab).abs

    diff * (diff + 1) / 2
  end
end.min

pp sol1
pp sol2
