require './commons/assert'
require 'matrix'

def part_one(input, expansion = 2)
  universe = Matrix[*input.split("\n").map { |c| c.split('') }]

  void_rows = universe.row_vectors.each_index.filter { |i| universe.row_vectors[i].all? { |c| c == '.' } }
  void_columns = universe.column_vectors.each_index.filter { |i| universe.column_vectors[i].all? { |c| c == '.' } }

  galaxies = universe.each_with_index.select { |s, _, _| s == '#' }.map { |_, i, j| [i, j] }
  galaxies.combination(2).map do |s, f|
    extra = void_rows.filter { |r| (r > s[0] && r < f[0]) || (r < s[0] && r > f[0]) }.length +
            void_columns.filter { |c| (c > s[1] && c < f[1]) || (c < s[1] && c > f[1]) }.length

    (s[0] - f[0]).abs + (s[1] - f[1]).abs + (extra * (expansion - 1))
  end.sum
end

def part_two(input, expansion = 1_000_000)
  part_one(input, expansion)
end

def test
  example = %(...#......
.......#..
#.........
..........
......#...
.#........
.........#
..........
.......#..
#...#.....)

  assert part_one(example, 2), 374
  assert part_two(example, 10), 1030
  assert part_two(example, 100), 8410
  0
end
