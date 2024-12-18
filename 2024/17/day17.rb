# frozen_string_literal: true

MAX_PREFIX = 128

class Device
  attr_accessor :registers, :program

  def initialize(input)
    registers, program = input.split("\n\n")

    @initial_registers = registers.scan(/Register .: (\d+)/).flatten.map(&:to_i)
    @program = program.split[1].split(',').map(&:to_i)
    @two = {}

    reset
  end

  def reset
    @pointer = 0
    @registers = @initial_registers.dup
  end

  def combo(operand)
    case operand
    when 4
      @registers[0]
    when 5
      @registers[1]
    when 6
      @registers[2]
    else
      operand
    end
  end

  def adv(operand)
    numerator = @registers[0]

    denominator = 2**combo(operand)
    numerator / denominator
  end

  def run(initial = nil)
    output = []
    @registers[0] = initial if !initial.nil?

    while @pointer < @program.size
      opcode = @program[@pointer]
      operand = @program[@pointer + 1]

      jumped = false

      case opcode
      when 0
        @registers[0] = adv(operand)
      when 1
        @registers[1] ^= operand
      when 2
        @registers[1] = combo(operand) % 8
      when 3
        if @registers[0] != 0
          jumped = true
          @pointer = operand
        end
      when 4
        @registers[1] ^= @registers[2]
      when 5
        output << (combo(operand) % 8)

        break if !initial.nil? && output[output.size - 1] != (@program[output.size - 1])
      when 6
        @registers[1] = adv(operand)
      when 7
        @registers[2] = adv(operand)
      end

      @pointer += 2 if !jumped
    end

    reset

    output
  end

  def quine
    stack = []
    stack << [0, 0, []]
    min_value = Float::INFINITY

    visited = Set.new
    while !stack.empty?
      num, pointer, output = stack.pop

      if output == @program
        min_value = [min_value, num].min
        next
      end

      next if pointer >= @program.size

      (0...MAX_PREFIX).each do |prefix|
        new_num = prefix.to_s(2)
        new_num.concat(num.to_s(2)) if num != 0
        new_num = new_num.to_i(2)

        next if new_num >= min_value
        next if visited.include?(new_num)

        new_output = run(new_num)

        new_pointer = pointer
        new_pointer += 1 while new_pointer < @program.size && new_output[new_pointer] == @program[new_pointer]

        next if new_pointer == pointer

        visited << new_num
        stack << [new_num, new_pointer, new_output]
      end
    end

    min_value
  end
end

def solution
  input = File.read('input17.txt')
  device = Device.new(input)

  pp device.run.join(',')
  pp device.quine
end

solution
