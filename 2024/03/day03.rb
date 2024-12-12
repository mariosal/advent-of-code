# frozen_string_literal: true

DO = 'do'
DONT = "don't"

def solution
  input = File.read('input03.txt')

  # Part 1
  # groups = input.scan(/(?:mul\((\d+),(\d+)\))/)

  groups = input.scan(/(?:(do)\(\))|(?:(don't)\(\))|(?:mul\((\d+),(\d+)\))/)

  enabled = true

  groups.reduce(0) do |acc, group|
    enabled = true if group.include?(DO)
    enabled = false if group.include?(DONT)

    if enabled && group.compact.size == 2
      a, b = group.compact
      acc += a.to_i * b.to_i
    end

    acc
  end
end

pp solution
