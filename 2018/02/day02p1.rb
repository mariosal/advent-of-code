ids = File.read('input02.txt').split("\n").map { |id|
  id.chars.group_by { |v| v }.map { |_, v| v.size }
}

twos = ids.select { |id| id.find { |v| v == 2 } }.size
threes = ids.select { |id| id.find { |v| v == 3 } }.size

p twos * threes
