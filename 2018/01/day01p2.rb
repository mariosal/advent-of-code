memo = { 0 => 1 }
File.read('input01.txt').split("\n").map(&:to_i).cycle.reduce(0) { |acc, v|
  if memo[acc + v] == 1
    p acc + v
    break
  end

  memo[acc + v] ||= 0
  memo[acc + v] += 1

  acc + v
}
