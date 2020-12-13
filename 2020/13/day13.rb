input = File.read('input13.txt').split("\n")

timestamp = input[0].to_i
ids = input[1].split(',').reject { |id| id == 'x' }.map(&:to_i)

departures = ids.map { |id|
  (quotient, remainder) = timestamp.divmod(id)

  departure =
    if remainder == 0
      quotient
    else
      (quotient + 1) * id
    end

  [departure, id]
}

(departure, id) = departures.min
puts (departure - timestamp) * id

# Chinese Remainder Theorem from Rosetta Code
def extended_gcd(a, b)
  last_remainder, remainder = a.abs, b.abs
  x, last_x, y, last_y = 0, 1, 1, 0

  while remainder != 0
    last_remainder, (quotient, remainder) = remainder, last_remainder.divmod(remainder)
    x, last_x = last_x - quotient*x, x
    y, last_y = last_y - quotient*y, y
  end

  [last_remainder, last_x * (a < 0 ? -1 : 1)]
end

def invmod(e, et)
  g, x = extended_gcd(e, et)
  x % et
end

def chinese_remainder(mods, remainders)
  max = mods.reduce(:*)
  series = remainders.zip(mods).map { |r,m| (r * max * invmod(max / m, m) / m) }
  series.sum % max
end
# End of Rosetta Code

ids = input[1].split(',').map(&:to_i).map.with_index.reject { |id, _| id == 0 }.to_a

divisors = []
remainders = []
ids.each { |id, offset|
  divisors << id
  remainders << id - offset # x + 1 = a (mod n) => x = a - 1 (mod n)
}

puts chinese_remainder(divisors, remainders)
