MAX_ROWS = 127
MAX_COLS = 7

def binary_search(partition, max)
  lo = 0
  hi = max
  partition.each { |c|
    mi = (lo + hi) / 2

    if c > 0
      lo = mi + 1
    else
      hi = mi
    end
  }

  lo
end

boarding_passes = File.read('input05.txt').split("\n").map(&:chars)

seat_ids = boarding_passes.map { |boarding_pass|
  rows = boarding_pass[0..6].map { |c| c == 'B' ? 1 : -1 }
  cols = boarding_pass[7..9].map { |c| c == 'R' ? 1 : -1 }

  row = binary_search(rows, MAX_ROWS)
  col = binary_search(cols, MAX_COLS)

  row * 8 + col
}.sort

puts seat_ids.max

seat_ids.each_cons(2) { |a, b|
  if b - a > 1
    puts (a + b) / 2
  end
}
