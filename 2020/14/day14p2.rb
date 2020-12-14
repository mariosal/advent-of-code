BIT_SIZE = 36

def combinations(bits, n = 0)
  return [bits.to_i(2)] if n == bits.size

  if bits[n] == 'X'
    zero = bits.dup
    zero[n] = '0'

    one = bits.dup
    one[n] = '1'

    combinations(zero, n + 1) + combinations(one, n + 1)
  else
    combinations(bits, n + 1)
  end
end

def mask(value, bitmask)
  bits = value.to_i.to_s(2).rjust(BIT_SIZE, '0').chars

  bits.zip(bitmask).map { |bit, bitmask_bit|
    bitmask_bit == '0' ? bit : bitmask_bit
  }.join
end

memory = {}
bitmask = ''

File.read('input14.txt').split("\n").each { |line|
  (variable, value) = line.split(' = ')

  case variable
  when 'mask'
    bitmask = value.chars
  when /mem\[(\d+)\]/
    combinations(mask($1, bitmask)).each { |combination|
      memory[combination] = value.to_i
    }
  end
}

puts memory.values.sum
