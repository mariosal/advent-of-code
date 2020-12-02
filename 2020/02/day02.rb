policies = File.read('input02.txt').split("\n")

puts policies.count { |policy|
  /(?<min>\d+)-(?<max>\d+) (?<letter>\w): (?<password>\w+)/ =~ policy
  appearances = password.count(letter)

  min.to_i <= appearances && appearances <= max.to_i
}

puts policies.count { |policy|
  /(?<min>\d+)-(?<max>\d+) (?<letter>\w): (?<password>\w+)/ =~ policy

  password.split('').values_at(min.to_i - 1, max.to_i - 1).count(letter) == 1
}
