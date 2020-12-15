LIMIT = 30000000

starting_numbers = File.read('input15.txt').split(',').map(&:to_i)

spoken_numbers = {}
starting_numbers.each.with_index(1) { |starting_number, turn|
  spoken_numbers[starting_number] = turn
}

last_spoken_number = starting_numbers.last
(starting_numbers.size + 1..LIMIT).each { |turn|
  last_spoken_number =
    if spoken_numbers.key?(last_spoken_number)
      last_spoken_turn = spoken_numbers[last_spoken_number]
      spoken_numbers[last_spoken_number] = turn - 1

      turn - 1 - last_spoken_turn
    else
      spoken_numbers[last_spoken_number] = turn - 1

      0
    end
}

puts last_spoken_number
