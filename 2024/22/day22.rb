# frozen_string_literal: true

class Generator
  def initialize(seed)
    @seed = seed
  end

  def next
    process1
    process2
    process3

    @seed
  end

  def process1
    mix(@seed * 64)
    prune
  end

  def process2
    mix(@seed / 32)
    prune
  end

  def process3
    mix(@seed * 2048)
    prune
  end

  def mix(value)
    @seed ^= value
  end

  def prune
    @seed %= 16_777_216
  end
end

def solution
  secret_numbers = File.read('input22.txt').split("\n").map(&:to_i)

  sequences = secret_numbers.map do |secret_number|
    gen = Generator.new(secret_number)

    sequence = [secret_number]
    2000.times do
      sequence << gen.next
    end
    sequence
  end
  pp sequences.sum(&:last)

  total_freq = Hash.new(0)
  sequences.each do |sequence|
    sequence = sequence.map { |n| n % 10 }

    freq = {}

    (0...(sequence.size - 5)).each do |i|
      diff_sequence = sequence[i, 5].each_cons(2).map { |a, b| b - a }

      freq[diff_sequence] ||= sequence[i + 4]
    end

    freq.each do |k, v|
      total_freq[k] += v
    end
  end

  pp total_freq.values.max
end

solution
