numbers = File.read('input03.txt').split("\n")

def count_freq(numbers, index)
  numbers.each_with_object(Hash.new(0)) { |number, freq|
    freq[number[index]] += 1
  }
end

gamma = ''
epsilon = ''
(0...numbers[0].size).each { |index|
  freq = count_freq(numbers, index)

  gamma += freq.max_by { |_, v| v }[0]
  epsilon += freq.min_by { |_, v| v }[0]
}

pp gamma.to_i(2) * epsilon.to_i(2)

def pool(numbers, common)
  index = 0
  while numbers.size > 1
    freq = count_freq(numbers, index)

    bit =
    case common
    when :most
      freq["0"] > freq["1"] ? "0" : "1"
    when :least
      freq["0"] > freq["1"] ? "1" : "0"
    end

    numbers = numbers.select { |number|
      number[index] == bit
    }

    index += 1
  end

  numbers[0].to_i(2)
end

pp pool(numbers, :most) * pool(numbers, :least)
