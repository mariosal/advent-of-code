require 'set'

CYCLES = 6

def neighbors(cube)
  (x, y, z, w) = cube

  (-1..1).each_with_object(Set.new) { |dw, neighbors|
    (-1..1).each { |dz|
      (-1..1).each { |dx|
        (-1..1).each { |dy|
          next if dx == 0 && dy == 0 && dz == 0 && dw == 0

          neighbors << [x + dx, y + dy, z + dz, w + dw]
        }
      }
    }
  }
end

def active_cubes(grid)
  grid.select { |_, value| value }.map(&:first)
end

grid = Hash.new(false)

File.read('input17.txt').split("\n").each_with_index { |line, y|
  line.chars.each_with_index { |value, x|
    grid[[x, y, 0, 0]] = value == '#' ? true : false
  }
}

CYCLES.times {
  cubes = active_cubes(grid).each_with_object(Set.new) { |active_cube, cubes|
    cubes << active_cube
    cubes.merge(neighbors(active_cube))
  }

  new_grid = grid.dup
  cubes.each { |cube|
    active_neighbors = neighbors(cube).count { |neighbor|
      grid[neighbor]
    }

    if grid[cube] && ![2, 3].include?(active_neighbors)
      new_grid[cube] = false
    elsif !grid[cube] && active_neighbors == 3
      new_grid[cube] = true
    end
  }
  grid = new_grid
}

puts active_cubes(grid).size
