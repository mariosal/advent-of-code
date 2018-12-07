require 'set'

class Graph
  attr_reader :edges

  def initialize(edges)
    @edges = edges
  end

  def topo_sort
    @visited = SortedSet.new
    @topo_nodes = []

    nodes.each do |node|
      dfs(node)
    end

    @topo_nodes
  end

  private

  attr_reader :topo_nodes, :visited

  def adj_list
    @adj_list ||= edges.sort.reduce(Hash.new { |h, k| h[k] = [] }) do |acc, edge|
      acc[edge.src] << edge.trg
      acc
    end
  end

  def dfs(node)
    return [] if visited.include?(node)

    visited << node

    adj_list[node].each do |trg|
      dfs(trg)
    end

    topo_nodes.unshift(node)
  end

  def nodes
    @nodes ||= edges.reduce([]) do |acc, edge|
      acc << edge.src
      acc << edge.trg
      acc
    end.uniq.sort.reverse
  end
end

class Edge
  attr_reader :src, :trg

  def initialize(src, trg)
    @src = src
    @trg = trg
  end

  def <=>(other)
    return -(trg <=> other.trg) if src == other.src

    src <=> other.src
  end
end

edges = File.read('input07.txt').split("\n").map do |edge|
  Edge.new(*/^\w+ (\w).+(\w) \w+ \w+\.$/.match(edge).to_a.drop(1))
end

graph = Graph.new(edges)
puts graph.topo_sort.join
