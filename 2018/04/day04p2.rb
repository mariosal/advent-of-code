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

sleep_minutes = Hash.new do |hash, key|
  hash[key] = Array.new(60, 0)
end
sleep_durations.each do |(guard, start, finish)|
  (start...finish).each do |minute|
    sleep_minutes[guard][minute] += 1
  end
end

sleep_minutes = sleep_minutes.map do |k, v|
  [k, v.each_with_index.max]
end.to_h

max_guard = 0
max_minute = 0
max_freq = 0
sleep_minutes.each do |guard, (freq, minute)|
  next if max_freq >= freq

  max_freq = freq
  max_minute = minute
  max_guard = guard
end

puts max_guard * max_minute
