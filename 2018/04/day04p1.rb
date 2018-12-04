require 'date'

class Action
  attr_reader :datetime, :action
  attr_accessor :guard

  def initialize(datetime, action)
    @datetime = DateTime.parse(datetime)
    @action = parse_action(action)
  end

  def parse_action(action)
    if /Guard #(?<guard>\d+) begins shift/ =~ action
      @guard = guard.to_i
      :BEGIN
    elsif /falls asleep/ =~ action
      :SLEEP
    else
      :WAKEUP
    end
  end

  def <=>(other)
    datetime <=> other.datetime
  end
end

def set_guard(actions)
  guard = 0
  actions.each do |action|
    if action.action == :BEGIN
      guard = action.guard
    else
      action.guard = guard
    end
  end
end

actions = File.read('input04.txt').split("\n").map do |action|
  Action.new(*action.scan(/\[(.*)\] (.+)$/).first)
end.sort

set_guard(actions)

sleep_durations = actions.each_cons(2).select do |(action1, action2)|
  action1.action == :SLEEP && action2.action == :WAKEUP
end.map do |(action1, action2)|
  [action1.guard, action1.datetime.minute, action2.datetime.minute]
end

guard_sleep = Hash.new(0)
sleep_durations.each do |(guard, start, finish)|
  guard_sleep[guard] += finish - start
end

max_sleep = 0
max_guard = 0
guard_sleep.each do |guard, total_sleep|
  if max_sleep < total_sleep
    max_sleep = total_sleep
    max_guard = guard
  end
end

sleep_minutes = Array.new(60, 0)
sleep_durations.each do |(guard, start, finish)|
  next if guard != max_guard

  (start...finish).each do |minute|
    sleep_minutes[minute] += 1
  end
end

max_freq = 0
max_minute = 0
sleep_minutes.each.with_index do |freq, minute|
  if max_freq < freq
    max_freq = freq
    max_minute = minute
  end
end

puts max_guard * max_minute
