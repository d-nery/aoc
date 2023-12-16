require './commons/assert'
require 'matrix'
require 'set'

def walk_laser(grid, laser)
  states = Set[]
  energized = Matrix.zero(grid.row_count, grid.column_count)

  queue = [laser]
  until queue.empty?
    l = queue.shift
    l[0] += l[1]

    next if l[0].any?(&:negative?)

    case grid[*l[0]]
    when nil
      next
    when '|'
      if l[1][1] != 0
        l[1] = Vector[1, 0]
        queue.push([l[0].clone, Vector[-1, 0]])
      end
    when '-'
      if l[1][0] != 0
        l[1] = Vector[0, 1]
        queue.push([l[0].clone, Vector[0, -1]])
      end
    when '/'
      if l[1] == Vector[0, 1]
        l[1] = Vector[-1, 0]
      elsif l[1] == Vector[0, -1]
        l[1] = Vector[1, 0]
      elsif l[1] == Vector[1, 0]
        l[1] = Vector[0, -1]
      elsif l[1] == Vector[-1, 0]
        l[1] = Vector[0, 1]
      end
    when '\\'
      if l[1] == Vector[0, 1]
        l[1] = Vector[1, 0]
      elsif l[1] == Vector[0, -1]
        l[1] = Vector[-1, 0]
      elsif l[1] == Vector[1, 0]
        l[1] = Vector[0, 1]
      elsif l[1] == Vector[-1, 0]
        l[1] = Vector[0, -1]
      end
    end

    energized[*l[0]] += 1

    next if states.include? l.hash

    queue.push(l)
    states.add(l.hash)
  end

  energized
end

def part_one(input)
  grid = Matrix[*input.split("\n").map { _1.split('') }]
  laser = [Vector[0, -1], Vector[0, 1]]

  energized = walk_laser(grid, laser)
  energized.count(&:positive?)
end

def part_two(input)
  grid = Matrix[*input.split("\n").map { _1.split('') }]
  lasers = (0...grid.row_count).map { |i| [Vector[i, -1], Vector[0, 1]] } +
           (0...grid.row_count).map { |i| [Vector[i, grid.row_count], Vector[0, -1]] } +
           (0...grid.column_count).map { |i| [Vector[-1, i], Vector[1, 0]] } +
           (0...grid.column_count).map { |i| [Vector[grid.column_count, i], Vector[-1, 0]] }

  lasers.map { |s| walk_laser(grid, s).count(&:positive?) }.max
end

def test
  example = %(.|...\\....
|.-.\\.....
.....|-...
........|.
..........
.........\\
..../.\\\\..
.-.-/..|..
.|....-|.\\
..//.|....)

  assert part_one(example), 46
  assert part_two(example), 51
  0
end
