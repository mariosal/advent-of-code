class Tree
  def initialize(input)
    @root = parse(input.reverse)
  end

  def sum_metadata
    root.sum_metadata
  end

  private

  attr_reader :root

  def parse(input)
    return if input.empty?

    node = Node.new
    (num_metadata, num_children) = input.pop(2)

    num_children.times do
      node.children << parse(input)
    end

    node.metadata = input.pop(num_metadata)

    node
  end
end

class Node
  attr_reader :children
  attr_accessor :metadata

  def initialize
    @children = []
    @metadata = []
  end

  def sum_metadata
    metadata.reduce(:+) + children.map(&:sum_metadata).reduce(0, :+)
  end
end

input = File.read('input08.txt').strip.split(' ').map(&:to_i)

tree = Tree.new(input)
p tree.sum_metadata
