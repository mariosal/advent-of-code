# frozen_string_literal: true

class Stone
  attr_reader :id

  def initialize(id)
    @id = id
  end

  def blink
    return [Stone.new(1)] if @id == 0

    digits = @id.to_s

    if digits.size.even?
      left = digits[...digits.size / 2].to_i
      right = digits[digits.size / 2..].to_i

      return [Stone.new(left), Stone.new(right)]
    end

    [Stone.new(@id * 2024)]
  end

  def hash
    id.hash
  end

  def eql?(other)
    id == other.id
  end
end

class Game
  def initialize(ids)
    @stones = ids.map { |id| Stone.new(id) }
  end

  def blink(times)
    freq = @stones.tally(Hash.new(0))

    times.times do |_|
      new_freq = freq.dup

      freq.each do |stone, value|
        next if value == 0

        new_stones = stone.blink

        new_freq[stone] -= value
        new_stones.each do |new_stone|
          new_freq[new_stone] += value
        end
      end

      freq = new_freq
    end

    freq.values.sum
  end
end

def solution
  ids = File.read('input11.txt').split.map(&:to_i)

  pp Game.new(ids).blink(25)
  Game.new(ids).blink(75)
end

pp solution
