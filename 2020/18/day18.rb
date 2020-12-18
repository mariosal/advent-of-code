ORDER = {
  :+ => 2,
  :* => 1,
  :'(' => 3
}

def lex(string)
  string.gsub(/\s/, '').chars.map { |char|
    if /\d/.match?(char)
      char.to_i
    else
      char.to_sym
    end
  }
end

def parse(tokens)
  output = []
  operators = []

  while !tokens.empty?
    token = tokens.shift

    case token
    when :')'
      while operators.last != :'('
        output << operators.pop
      end

      operators.pop # Discard "("
    when *ORDER.keys
      # Push operators with higher precendence to the ouput
      if !operators.empty? && leq(token, operators.last)
        output << operators.pop
      end

      operators << token
    when Integer
      output << token
    end
  end

  output.concat(operators.reverse)
end

def leq(a, b)
  ![a, b].include?(:'(') && ORDER[a] <= ORDER[b]
end

def eval(tokens)
  stack = []

  while !tokens.empty?
    token = tokens.shift

    case token
    when Integer
      stack << token
    when Symbol
      right = stack.pop
      left = stack.pop

      stack << left.send(token, right)
    end
  end

  stack.pop
end

puts File.read('input18.txt').split("\n").map { |line|
  eval(parse(lex(line)))
}.sum
