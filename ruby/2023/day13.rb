require './commons/assert'
require 'matrix'

def simmetric?(line)
  return false if line.nil? || line.length.odd? || line.empty?

  line[0...line.length / 2] == line[line.length / 2..].reverse
end

def summarize(pattern, smudge_value = 0)
  # rows first
  row = pattern[0, 0..]
  row.length.times do |i|
    v = row[i..].length / 2 + i
    return v if simmetric?(row[i..]) && pattern.row_vectors.all? { |p| simmetric?(p[i..]) } && v != smudge_value
  end

  # in reverse
  row = pattern[0, 0..].reverse
  row.length.times do |i|
    v = row.length - (row[i..].length / 2 + i)
    return v if simmetric?(row[i..]) && pattern.row_vectors.all? do |p|
                  simmetric?(p[0..].reverse[i..])
                end && v != smudge_value
  end

  # columns
  column = pattern.t[0, 0..]
  column.length.times do |i|
    v = (column[i..].length / 2 + i) * 100
    return v if simmetric?(column[i..]) && pattern.column_vectors.all? { |p| simmetric?(p[i..]) } && v != smudge_value
  end

  # in reverse
  column = pattern.t[0, 0..].reverse
  column.length.times do |i|
    v = (column.length - (column[i..].length / 2 + i)) * 100
    return v if simmetric?(column[i..]) && pattern.column_vectors.all? do |p|
                  simmetric?(p[0..].reverse[i..])
                end && v != smudge_value
  end

  0
end

def part_one(input)
  patterns = input.split("\n\n").map { |p| Matrix[*p.split("\n").map { _1.split('') }] }
  patterns.map { summarize(_1) }.sum
end

def part_two(input)
  patterns = input.split("\n\n").map { |p| Matrix[*p.split("\n").map { _1.split('') }] }
  patterns.map do |p|
    original_summary = summarize(p)
    p.each_with_index do |original, i, j|
      p[i, j] = original == '#' ? '.' : '#'
      v = summarize(p, original_summary)
      break v if v != 0

      p[i, j] = original
    end
  end.sum
end

def test
  example = %(#.##..##.
..#.##.#.
##......#
##......#
..#.##.#.
..##..##.
#.#.##.#.

#...##..#
#....#..#
..##..###
#####.##.
#####.##.
..##..###
#....#..#)

  assert part_one(example), 405
  assert part_two(example), 400
  0
end
