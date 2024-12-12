# frozen_string_literal: true

class Lanternfish
  NEW_TIMER = 9
  RESET_TIMER = 6

  def initialize(timer = NEW_TIMER)
    @timer = timer
  end

  attr_reader :timer

  def tick(list)
    if @timer == 0
      @timer = RESET_TIMER
      list << self.class.new
    else
      @timer -= 1
    end
  end
end

timers = Array.new(9, 0)

File.read('input06.txt').split(',').each do |timer|
  timers[timer.to_i + 1] += 1
end

257.times do
  new_fish = timers[0]
  (0...timers.size - 1).each do |i|
    timers[i] = timers[i + 1]
  end
  timers[6] += new_fish
  timers[8] = new_fish
end

pp timers.sum
