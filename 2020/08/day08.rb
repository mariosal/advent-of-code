def terminates?(instructions)
  accumulator = 0
  position = 0
  size = instructions.size
  visited = Array.new(size, false)

  while position < size && !visited[position]
    (operation, argument) = instructions[position]
    visited[position] = true

    case operation
    when 'acc'
      accumulator += argument
    when 'jmp'
      next position += argument
    end

    position += 1
  end

  [position == size, accumulator]
end

def swap!(instruction)
  case instruction[0]
  when 'jmp'
    instruction[0] = 'nop'
  when 'nop'
    instruction[0] = 'jmp'
  end
end

instructions = File.read('input08.txt').split("\n").map { |instruction|
  (operation, argument) = instruction.split(' ')

  [operation, argument.to_i]
}

instructions.each { |instruction|
  next if !['jmp', 'nop'].include?(instruction[0])

  swap!(instruction)
  (terminated, accumulator) = terminates?(instructions)
  swap!(instruction)

  if terminated
    puts accumulator
    break
  end
}
