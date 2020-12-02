expenses = File.read('input01.txt').split("\n").map(&:to_i)

(0...expenses.size).each { |i|
  (i...expenses.size).each { |j|
    values = expenses.values_at(i, j)

    if values.sum == 2020
      puts values.reduce(:*)
    end
  }
}

(0...expenses.size).each { |i|
  (i...expenses.size).each { |j|
    (j...expenses.size).each { |k|
      values = expenses.values_at(i, j, k)

      if values.sum == 2020
        puts values.reduce(:*)
      end
    }
  }
}
