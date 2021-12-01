def count_increments(array)
  array.each_cons(2).count { |a, b| a < b }
end

depths = File.read('input01.txt').split("\n").map(&:to_i)

pp count_increments(depths)
pp count_increments(depths.each_cons(3).map(&:sum))
