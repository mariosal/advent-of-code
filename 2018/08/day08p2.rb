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

    input.pop(num_metadata).each do |metadatum|
      if num_children == 0
        node.metadata << metadatum
      elsif metadatum.between?(1, num_children)
        node.metadata << metadatum - 1
      end
    end

    node
  end
end

class Node
  attr_reader :children, :metadata

  def initialize
    @children = []
    @metadata = []
  end

  def sum_metadata
    if children.empty?
      metadata.reduce(0, :+)
    else
      children.values_at(*metadata).map(&:sum_metadata).reduce(0, :+)
    end
  end
end

input = File.read('input08.txt').strip.split(' ').map(&:to_i)

tree = Tree.new(input)
p tree.sum_metadata
