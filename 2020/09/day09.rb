PREAMBLE = 25

def sums(nums)
  (0...nums.size).each_with_object([]) { |i, acc|
    (0...i).each { |j|
      acc << nums[i] + nums[j] if nums[i] != nums[j]
    }
  }
end

data = File.read('input09.txt').split("\n").map(&:to_i)

invalid = (0...data.size).find { |i|
  next if i < PREAMBLE

  window = data[(i - PREAMBLE)...i]
  if !sums(window).include?(data[i])
    data[i]
  end
}

puts data[invalid]

weak = nil
(0...data.size).each { |i|
  sum = 0
  min = max = data[i]
  (i...data.size).each { |j|
    sum += data[j]
    min = [min, data[j]].min
    max = [max, data[j]].max

    if sum == data[invalid]
      break weak = min + max
    end
  }

  break if weak
}

puts weak
