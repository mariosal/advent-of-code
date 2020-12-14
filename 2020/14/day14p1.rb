BIT_SIZE = 36

def mask(value, bitmask)
  bits = value.to_i.to_s(2).rjust(BIT_SIZE, '0').chars

  bits.zip(bitmask).map { |bit, bitmask_bit|
    bitmask_bit == 'X' ? bit : bitmask_bit
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
    memory[$1.to_i] = mask(value, bitmask).to_i(2)
  end
}

puts memory.values.sum
