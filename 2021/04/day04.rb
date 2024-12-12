# frozen_string_literal: true

REQUIRED_FIELDS = {
  'byr' => /^19[2-9][0-9]|200[0-2]$/,
  'iyr' => /^20(1[0-9]|20)$/,
  'eyr' => /^20(2[0-9]|30)$/,
  'hgt' => /^(1([5-8][0-9]|9[0-3])cm|(59|6[0-9]|7[0-6])in)$/,
  'hcl' => /^#[0-9a-f]{6}$/,
  'ecl' => /^(amb|blu|brn|gry|grn|hzl|oth)$/,
  'pid' => /^\d{9}$/
}.freeze

input = File.read('input04.txt').split("\n\n")

draw = input[0].split(',').map(&:to_i)

boards = []
visited = []
(1...input.size).each do |i|
  boards << input[i].split("\n").map { |v| v.split.map(&:to_i) }
  visited << input[i].split("\n").map { |v| v.split.map { |_| false } }
end

def mark(boards, visited, number)
  boards.each_with_index do |board, index|
    (0...board.size).each do |i|
      (0...board[i].size).each do |j|
        visited[index][i][j] = true if board[i][j] == number
      end
    end
  end
end

def finalize(boards, visited, already_won, draw, win_draw, win_unmarked)
  visited.each_with_index do |board, index|
    (0...board.size).each do |i|
      found = (0...board[i].size).all? do |j|
        board[i][j]
      end

      next unless found && !already_won.include?(index)

      win_unmarked[index] = unmarked(boards[index], board).sum * draw
      win_draw[index] = draw
      already_won << index
    end

    (0...board[0].size).each do |i|
      found = (0...board.size).all? do |j|
        board[j][i]
      end

      next unless found && !already_won.include?(index)

      win_unmarked[index] = unmarked(boards[index], board).sum * draw
      win_draw[index] = draw
      already_won << index
    end
  end
end

def unmarked(board, visited)
  ret = []
  (0...board.size).each do |i|
    (0...board[i].size).each do |j|
      ret << board[i][j] if !visited[i][j]
    end
  end
  ret
end

win_unmarked = {}
win_draw = {}
already_won = []
draw.each do |number|
  mark(boards, visited, number)
  finalize(boards, visited, already_won, number, win_draw, win_unmarked)
end

pp win_unmarked[already_won.first]
pp win_unmarked[already_won.last]
