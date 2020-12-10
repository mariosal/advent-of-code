jolts = File.read('input10.txt').split("\n").map(&:to_i).sort

jolts.prepend(0)
jolts.append(jolts.last + 3)

diff = Hash.new(0)
jolts.each_cons(2) { |a, b|
  diff[b - a] += 1
}

puts diff[1] * diff[3]

def compat?(a, b)
  a - b <= 3
end

def compat?(jolts, i, j)
  i < jolts.size && j < jolts.size && (jolts[i] - jolts[j]).abs <= 3
end

def ways(jolts, i)
  @memo ||= {}
  return @memo[i] if @memo.key?(i)

  return 1 if i == jolts.size - 1

  @memo[i] = 0
  @memo[i] += ways(jolts, i + 1) if compat?(jolts, i, i + 1)
  @memo[i] += ways(jolts, i + 2) if compat?(jolts, i, i + 2)
  @memo[i] += ways(jolts, i + 3) if compat?(jolts, i, i + 3)

  @memo[i]
end

puts ways(jolts, 0)
