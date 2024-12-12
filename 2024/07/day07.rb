# frozen_string_literal: true

OPERATORS = %i[+ *].freeze
OPERATORS2 = %i[+ * concat].freeze

class Integer
  def concat(rhs)
    (to_s + rhs.to_s).to_i
  end
end

class Equation
  attr_reader :lhs

  def initialize(string, operators)
    @lhs, *@rhs = string.scan(/\d+/).map(&:to_i)
    @operators = operators
  end

  def solvable?
    @operators.repeated_permutation(@rhs.size - 1) do |permutation|
      expression = @rhs[0]

      (1...@rhs.size).each do |i|
        expression = expression.send(permutation[i - 1], @rhs[i])
      end

      return true if @lhs == expression
    end

    false
  end
end

def solution
  lines = File.read('input07.txt').split("\n")

  [OPERATORS, OPERATORS2].map do |operators|
    equations = lines.map { |line| Equation.new(line, operators) }
    equations.select(&:solvable?).sum(&:lhs)
  end
end

pp solution
