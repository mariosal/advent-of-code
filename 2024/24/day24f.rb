# frozen_string_literal: true

OPERATORS = {
  'AND' => :&,
  'OR' => :|,
  'XOR' => :^
}.freeze

require 'tsort'

class Hash
  include TSort
  alias tsort_each_node each_key
  def tsort_each_child(node, &)
    fetch(node).each(&)
  end
end

class Wire
  attr_reader :value, :key
  attr_accessor :operands, :operator

  def initialize(key)
    @key = key
    @ready = false
  end

  def reset
    return unless @operands

    @value = nil
    @ready = false
  end

  def value=(value)
    @value = value
    @ready = true
  end

  def ready?
    return true if @ready

    @ready = @operands.all? { |operand| !operand.value.nil? }
  end

  def operate
    return if !ready?
    return if !@value.nil?

    @value = @operands[0].value.send(@operator, @operands[1].value)
  end

  def swap(other)
    @operands, other.operands = other.operands, @operands
    @operator, other.operator = other.operator, @operator
  end
end

def num(wires, prefix)
  keys = wires.keys.select { |key| key.start_with?(prefix) }.sort.reverse

  ans = 0
  keys.each do |key|
    return -1 if wires[key].value.nil?

    ans *= 2
    ans += wires[key].value
  end

  ans
end

def solve(wires, reset_wires = Set.new)
  wires.each_value do |wire|
    wire.reset if reset_wires.include?(wire.key)
  end

  resolved = wires.reject { |_, wire| wire.value.nil? }.keys.to_set
  prev = -1
  loop do
    break if resolved.size == wires.size
    break if prev == resolved.size

    prev = resolved.size

    wires.each_value do |wire|
      wire.operate

      resolved << wire.key if wire.value
    end
  end
end

def find_all_wires(wires, key, all_wires)
  return unless wires[key].operands

  all_wires << key

  wires[key].operands.each do |operand|
    find_all_wires(wires, operand.key, all_wires)
  end
end

def four_groups(array)
  max_num = ('3' * array.size).to_i(4)

  groups = []
  (0..max_num).each do |num|
    bits = num.to_s(4).rjust(array.size, '0').chars
    next if bits.to_set.size != 4

    group = Array.new(4) { Set.new }
    bits.each_with_index do |bit, i|
      group[bit.to_i] << array[i]
    end

    groups << group.to_set
  end

  groups
end

def solution
  wires = Hash.new { |h, k| h[k] = Wire.new(k) }

  initial_values, gates = File.read('input24.txt').split("\n\n").map do |lines|
    lines.split("\n")
  end

  initial_values.each do |line|
    name, value = line.split(': ')

    wires[name].value = value.to_i
  end

  edges = Hash.new { |h, k| h[k] = Set.new }
  gates.each do |line|
    input, output = line.split(' -> ')

    operand1, operator, operand2 = input.split

    edges[output] << operand1
    edges[output] << operand2
    edges[operand1] ||= []
    edges[operand2] ||= []
    # edges[operand1] << output
    # edges[operand2] << output
    # edges[output] ||= []
    wires[output].operands = [wires[operand1], wires[operand2]]
    wires[output].operator = OPERATORS[operator]
  end

  # wire_gates = wires.select { |_, wire| !wire.operands.nil? }.keys
  # pp wire_gates.size
  # wires['z35'].swap(wires['z34'])
  # wires['z26'].swap(wires['z25'])
  # wires['z24'].swap(wires['z17'])
  # wires['z07'].swap(wires['z33'])
  # wires['z08'].swap(wires['z32'])
  # wires['z10'].swap(wires['z09'])
  pp edges.tsort
  return
  solve(wires)
  x = num(wires, 'x')
  y = num(wires, 'y')
  z = num(wires, 'z')
  pp z

  a = (x + y).to_s(2)
  b = z.to_s(2)

  pp a
  pp b

  problematic_wires = []
  (0...a.size).each do |i|
    if a[i] != b[i]
      problematic_wires << "z#{(a.size - i - 1).to_s.rjust(2, '0')}"
      # problematic_wires << "z#{i.to_s.rjust(2, "0")}"
    end
  end
  pp problematic_wires
  # total = four_groups(problematic_wires)
  # pp total.size
  # return

  Set.new
  all_problematic_wiresp = Hash.new { |h, k| h[k] = Set.new }
  problematic_wires.each do |key|
    find_all_wires(wires, key, all_problematic_wiresp[key])
  end
  foo = Set.new
  find_all_wires(wires, 'z01', foo)
  pp foo
  return
  # res = Set.new(all_problematic_wiresp.first.last)
  res = Set.new
  all_problematic_wiresp.each do |k, wires|
    pp [k, wires.size]
    res |= wires
  end
  pp res.size
  # all_problematic_wiresp.keys.sort.permutation(2) do |a, b|
  #   res = all_problematic_wiresp[a] & all_problematic_wiresp[b]

  #   if res.size > 0
  #     pp [a, b]
  #   end
  # end
  pp res.size
  return
  # pp all_problematic_wires.size
  # solve for [z00101]
  # swap

  # pp wires.select { |key, _| key.start_with?('z') }.keys.sort
  # wire_gates.each do |a|
  #   wire_gates.each do |b|
  #     wire_gates.each do |c|
  #       wire_gates.each do |d|
  #         wire_gates.each do |e|
  #           wire_gates.each do |f|
  #             wire_gates.each do |g|
  #               wire_gates.each do |h|
  #   permutation = [a, b, c, d, e, f, g, h]
  #   next if permutation.to_set.size != 8
  #   permutation.each_slice(2) do |a, b|
  #     wires[a].swap(wires[b])
  #   end

  #   solve(wires)

  #   z = num(wires, 'z')

  #   if x + y == z
  #     pp permutation.sort.join(',')
  #     break
  #   end

  #   permutation.each_slice(2) do |a, b|
  #     wires[a].swap(wires[b])
  #   end
  #   permutation.each_slice(2) do |a, b|
  #     wires[a].swap(wires[b])
  #   end

  #   solve(wires)

  #   x = num(wires, 'x')
  #   y = num(wires, 'y')
  #   z = num(wires, 'z')

  #   if x + y == z
  #     pp permutation.sort.join(',')
  #     break
  #   end

  #   permutation.each_slice(2) do |a, b|
  #     wires[a].swap(wires[b])
  #   end
  #               end
  #             end
  #           end
  #         end
  #       end
  #     end
  #   end
  # end

  problematic_wires = res.to_a
  problematic_wires.permutation(8) do |permutation|
    # permutation = ['z05', 'z00', 'z02', 'z01']
    # pp permutation
    permutation.each_slice(2) do |a, b|
      wires[a].swap(wires[b])
    end

    solve(wires, res)

    # x = num(wires, 'x')
    # y = num(wires, 'y')
    z = num(wires, 'z')

    if x + y == z
      pp permutation.sort.join(',')
      break
    end

    permutation.each_slice(2) do |a, b|
      wires[a].swap(wires[b])
    end
  end
end

solution
