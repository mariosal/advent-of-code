require 'set'

def getFields(input)
  input.split("\n").each_with_object({}) { |line, fields|
    /(?<key>[^:]+): (?<min1>\d+)-(?<max1>\d+) or (?<min2>\d+)-(?<max2>\d+)/ =~ line

    fields[key] = [[min1, max1], [min2, max2]].map { |v| v.map(&:to_i) }
  }
end

def getTickets(input)
  input.split("\n")[1..-1].map { |ticket| ticket.split(',').map(&:to_i) }
end

def valid?(fields, value)
  fields.values.flatten(1).any? { |min, max|
    min <= value && value <= max
  }
end

input = File.read('input16.txt').split("\n\n")

fields = getFields(input[0])
my_ticket = getTickets(input[1]).flatten
nearby_tickets = getTickets(input[2])

tickets = [my_ticket] + nearby_tickets

puts tickets.flatten.reject { |value|
  valid?(fields, value)
}.sum

valid_tickets = tickets.select { |ticket|
  ticket.all? { |value| valid?(fields, value) }
}

columns = valid_tickets.transpose
valid_keys = (0...my_ticket.size).map { |i|
  fields.select { |key, constraints|
    columns[i].all? { |value|
      constraints.any? { |min, max|
        min <= value && value <= max
      }
    }
  }.keys.to_set
}

loop {
  many_keys = false

  (0...valid_keys.size).each { |i|
    if valid_keys[i].size > 1
      many_keys = true
    else
      key = valid_keys[i].first

      (0...valid_keys.size).each { |j|
        valid_keys[j].delete(key) if i != j
      }
    end
  }

  break if !many_keys
}

puts my_ticket.zip(valid_keys.map(&:first)).select { |_, key|
  key.start_with?('departure')
}.map(&:first).reduce(:*)
