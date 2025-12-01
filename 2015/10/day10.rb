sequence = File.read('input10.txt').strip.chars

def tick(sequence)
  count = 0
  prev = nil
  result = ""
  sequence.each do |char|
    if !prev.nil? && prev != char
      result.concat(count.to_s + prev)
      count = 0
    end

    count += 1
    prev = char
  end

  result.concat(count.to_s + prev)

  result.chars
end

def dfs(sequence, depth)
  return sequence if depth == 0

  next_sequence = tick(sequence)
  dfs(next_sequence, depth - 1)
end

pp dfs(sequence, 50).size
