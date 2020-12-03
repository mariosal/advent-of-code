map = File.read('input03.txt').split("\n")

numCols = map[0].size

puts [[1, 1], [3, 1], [5, 1], [7, 1], [1, 2]].map { |dx, dy|
  trees = x = y = 0
  while y < map.size
    trees += 1 if map[y][x % numCols] == '#'
    x += dx
    y += dy
  end

  trees
}.reduce(:*)
