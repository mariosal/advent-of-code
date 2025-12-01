# frozen_string_literal: true

def find_groups_of_three(edges, start, groups, visited = Set.new([start]))
  if visited.size == 3
    groups << visited.sort
    return
  end

  edges[start].each do |neighbor|
    next 0 if visited.include?(neighbor) || !visited.subset?(edges[neighbor])

    visited << neighbor
    find_groups_of_three(edges, neighbor, groups, visited)
    visited.delete(neighbor)
  end
end

def find_largest_group(edges, start, visited = Set.new([start]))
  edges[start].each do |neighbor|
    next if visited.include?(neighbor) || !visited.subset?(edges[neighbor])

    visited << neighbor
    find_largest_group(edges, neighbor, visited)
  end

  visited
end

def solution
  connections = File.read('input23.txt').split("\n").map { |line| line.split('-') }

  edges = Hash.new { |h, k| h[k] = Set.new }
  connections.each do |source, target|
    edges[source] << target
    edges[target] << source
  end

  groups = Set.new
  edges.each_key do |node|
    next if !node.start_with?('t')

    find_groups_of_three(edges, node, groups)
  end
  pp groups.size

  max_group = Set.new
  edges.each_key do |node|
    group = find_largest_group(edges, node)

    max_group = group if max_group.size < group.size
  end

  pp max_group.sort.join(',')
end

solution
