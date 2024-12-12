# frozen_string_literal: true

def increasing?(sequence)
  sequence.each_cons(2).all? do |a, b|
    b >= a
  end
end

def safe?(sequence)
  (increasing?(sequence) || increasing?(sequence.reverse)) &&
    sequence.each_cons(2).all? do |a, b|
      diff = (a - b).abs

      diff >= 1 && diff <= 3
    end
end

def solution
  sequences = File.read('input02.txt').split("\n").map { |line| line.split.map(&:to_i) }

  sol1 = sequences.count do |sequence|
    safe?(sequence)
  end
  pp sol1

  sequences.count do |sequence|
    next true if safe?(sequence)

    (0...sequence.size).any? do |i|
      new_sequence = sequence[...i] + sequence[i + 1..]
      safe?(new_sequence)
    end
  end
end

pp solution
