require './commons/assert'
require 'matrix'
require 'pqueue'
require 'set'

def neigh(grid, point)
  return [point + Vector[1, 0]] if grid[*point] == 'v'
  return [point + Vector[-1, 0]] if grid[*point] == '^'
  return [point + Vector[0, 1]] if grid[*point] == '>'
  return [point + Vector[0, -1]] if grid[*point] == '<'

  [Vector[1, 0], Vector[-1, 0], Vector[0, 1], Vector[0, -1]].inject([]) do |neighs, dir|
    npos = point + dir

    # off grid
    next neighs unless npos[0] >= 0 && npos[0] < grid.row_count && npos[1] >= 0 && npos[1] < grid.column_count
    next neighs if grid[*npos] == '#'

    neighs << npos
  end
end

@visited = Set[]
def longest_path(grid, current, target, longest, distance)
  return distance if current == target

  @visited.add(current)

  neigh(grid, current).each do |npoint|
    next if @visited.include?(npoint)

    longest = [longest, longest_path(grid, npoint, target, longest, distance + 1)].max
  end

  @visited.delete(current)
  longest
end

def part_one(input)
  grid = Matrix[*input.split("\n").map { _1.split('') }]
  size = [grid.row_count, grid.column_count]
  start = Vector[0, 1]
  target = Vector[size[0] - 1, size[1] - 2]

  @visited = Set[]
  longest_path(grid, start, target, 0, 0)
end

def part_two(input)
  input.gsub!(/[><v^]/, '.')
  grid = Matrix[*input.split("\n").map { _1.split('') }]
  size = [grid.row_count, grid.column_count]
  start = Vector[0, 1]
  target = Vector[size[0] - 1, size[1] - 2]

  @visited = Set[]
  longest_path(grid, start, target, 0, 0)
end

def test
  example = %(#.#####################
#.......#########...###
#######.#########.#.###
###.....#.>.>.###.#.###
###v#####.#v#.###.#.###
###.>...#.#.#.....#...#
###v###.#.#.#########.#
###...#.#.#.......#...#
#####.#.#.#######.#.###
#.....#.#.#.......#...#
#.#####.#.#.#########v#
#.#...#...#...###...>.#
#.#.#v#######v###.###v#
#...#.>.#...>.>.#.###.#
#####v#.#.###v#.#.###.#
#.....#...#...#.#.#...#
#.#########.###.#.#.###
#...###...#...#...#.###
###.###.#.###v#####v###
#...#...#.#.>.>.#.>.###
#.###.###.#.###.#.#v###
#.....###...###...#...#
#####################.#)

  assert part_one(example), 94
  assert part_two(example), 154
  0
end
