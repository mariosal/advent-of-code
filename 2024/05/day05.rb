# frozen_string_literal: true

require 'tsort'

class Hash
  include TSort
  alias tsort_each_node each_key
  def tsort_each_child(node, &)
    fetch(node).each(&)
  end
end

def get_order_map(rules, update)
  relations = {}
  rules.each do |a, b|
    next unless update.include?(a) && update.include?(b)

    relations[a] ||= []
    relations[b] ||= []
    relations[a] << b
  end

  order = relations.tsort.reverse

  order.each_with_index.with_object({}) do |(page, index), order_map|
    order_map[page] = index
  end
end

def solution
  rules, updates = File.read('input05.txt').split("\n").partition do |line|
    line.include?('|')
  end

  rules = rules.map { |rule| rule.split('|').map(&:to_i) }
  updates = updates.reject!(&:empty?).map { |update| update.split(',').map(&:to_i) }

  correct_count = 0
  incorrect_count = 0

  updates.each do |update|
    order_map = get_order_map(rules, update)

    correct = update.each_cons(2).all? do |a, b|
      order_map[a] < order_map[b]
    end

    if correct
      middle = update[update.size / 2]
      correct_count += middle
    else
      incorrect_count += update.sort_by { |page| order_map[page] }[update.size / 2]
    end
  end

  [correct_count, incorrect_count]
end

pp solution
