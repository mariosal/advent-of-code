ids = File.read('input02.txt').split("\n").map(&:chars)

correct_boxes = ids.select do |id|
  ids.find do |other_id|
    id.select.with_index do |v, index|
      v != other_id[index]
    end.size == 1
  end
end

puts correct_boxes.first.select.with_index { |v, index|
  v == correct_boxes.last[index]
}.join
