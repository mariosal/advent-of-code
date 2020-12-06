forms = File.read('input06.txt').split("\n\n")

puts forms.map { |questions|
  questions.gsub("\n", '').chars.uniq.count
}.sum

puts forms.map { |questions|
  questions.split("\n").map(&:chars).reduce(:&).count
}.sum
