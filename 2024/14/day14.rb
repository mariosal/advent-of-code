# frozen_string_literal: true

BOUNDS = [101, 103].freeze
SECONDS = 100

class Robot
  attr_reader :p

  def initialize(input)
    matches = input.match(/p=(?<x>-?\d+),(?<y>-?\d+) v=(?<dx>-?\d+),(?<dy>-?\d+)/)
    @p = [matches[:x], matches[:y]].map(&:to_i)
    @v = [matches[:dx], matches[:dy]].map(&:to_i)
  end

  def tick(times)
    [(@p[0] + (times * @v[0])) % BOUNDS[0], (@p[1] + (times * @v[1])) % BOUNDS[1]]
  end
end

def solution
  robots = File.read('input14.txt').split("\n").map do |line|
    Robot.new(line)
  end

  # PART 1
  sol1 = robots.group_by do |robot|
    p = robot.tick(SECONDS)

    top_left = p[0] < BOUNDS[0] / 2 && p[1] < BOUNDS[1] / 2
    top_right = p[0] > BOUNDS[0] / 2 && p[1] < BOUNDS[1] / 2
    bottom_right = p[0] > BOUNDS[0] / 2 && p[1] > BOUNDS[1] / 2
    bottom_left = p[0] < BOUNDS[0] / 2 && p[1] > BOUNDS[1] / 2

    if top_left
      0
    elsif top_right
      1
    elsif bottom_right
      2
    elsif bottom_left
      3
    end
  end.reject { |k, _| k.nil? }.values.map(&:count).reduce(:*)

  pp sol1

  # Run the simulation a big number of times and check states where more than half of the robots are connected
  10_000.times do |i|
    visited = Set.new
    robots.each do |robot|
      visited << robot.tick(i + 1)
    end

    connected = visited.count do |x, y|
      (-1..1).any? do |dy|
        (-1..1).any? do |dx|
          next false if [dx, dx] == [0, 0]

          visited.include?([x + dx, y + dy])
        end
      end
    end

    next if connected < visited.size / 2

    (0...BOUNDS[1]).each do |y|
      (0...BOUNDS[0]).each do |x|
        if visited.include?([x, y])
          print '*'
        else
          print '.'
        end
      end
      puts
    end

    pp i + 1

    break
  end
end

solution
