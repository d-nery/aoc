require './commons/assert'
require 'set'

def roll!(line)
  i = 0
  while i < line.length
    next_square = line[i..].index('#') || line[i..].length
    c = line[i...next_square + i].count 'O'
    line[i...next_square + i] = ['O'] * c + ['.'] * (next_square - c)
    i += next_square + 1
  end
end

def cycle(grid)
  # north
  grid = grid.transpose
  grid.each { |row| roll!(row) }

  # west
  grid = grid.transpose
  grid.each { |row| roll!(row) }

  # south
  grid = grid.transpose
  grid.each do |row|
    row.reverse!
    roll!(row)
    row.reverse!
  end

  # east
  grid = grid.transpose
  grid.each do |row|
    row.reverse!
    roll!(row)
    row.reverse!
  end

  grid
end

def part_one(input)
  grid = input.split("\n").map { _1.split('') }.transpose
  grid.map do |row|
    roll!(row)
    row.each_with_index.map { |r, i| r == 'O' ? row.length - i : 0 }.sum
  end.sum
end

def part_two(input)
  grid = input.split("\n").map { _1.split('') }

  found = {}
  first_repeat = 1_000_000_000.times do |i|
    grid = cycle(grid)

    if found.key?(grid)
      #   puts "cycle found at #{i}"
      break i
    end

    found[grid] = i
  end

  remaining_cycles = (1_000_000_000 - (first_repeat + 1)) % (first_repeat - found[grid])
  remaining_cycles.times { grid = cycle(grid) }

  grid.each_with_index.map do |row, i|
    (grid.length - i) * row.count('O')
  end.sum
end

def test
  example = %(O....#....
O.OO#....#
.....##...
OO.#O....O
.O.....O#.
O.#..O.#.#
..O..#O..O
.......O..
#....###..
#OO..#....)

  assert part_one(example), 136
  assert part_two(example), 64
  0
end
