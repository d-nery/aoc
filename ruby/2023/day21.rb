require './commons/assert'
require 'set'

def possibilities(input, max_steps)
  walls = Set[]
  plots = input.split("\n").map { _1.split '' }

  possibilities = {}
  plots.each_with_index do |line, i|
    line.each_with_index do |v, j|
      possibilities[[i, j]] = 0 if v == 'S'
      walls << [i, j] if v == '#'
    end
  end

  max_steps.times do |s|
    new_p = Set[]
    possibilities.each_key do |k|
      i, j = k
      new_p << [i + 1, j] unless walls.include? [i + 1, j]
      new_p << [i - 1, j] unless walls.include? [i - 1, j]
      new_p << [i, j + 1] unless walls.include? [i, j + 1]
      new_p << [i, j - 1] unless walls.include? [i, j - 1]
    end
    new_p.each { |c| possibilities[c] = s + 1 unless possibilities.key?(c) }
  end

  possibilities
end

def part_one(input, steps = 64)
  possibilities(input, steps).values.filter { |v| v % 2 == steps % 2 }.count
end

def part_two(input)
  # grid size is 131x131, we need 65 steps to get to the edge + 131 to get to each next one
  # so we have this amount of sections each side and up/down
  sections = (26_501_365 - 65) / 131 # 202300

  # first section reaches stability at 127 steps (7769 possibilities), alternating to 7780 ->
  # i just printed visited squares in first section until i found this information
  # odd steps = 7780
  # even steps = 7769
  # adjacent sections have this inverted and etc: (at sections = 3)
  #             7769 ...
  #        7769 7780 7769
  #   7769 7780 7769 7780 7769 ...
  #        7769 7780 7769 ...
  #             7769 ...
  # At sections we'd have (sections+1)² * 7769 + sections² * 7780

  total = (sections + 1)**2 * 7769 + sections**2 * 7780

  # But the corners won't be fully visited, we walk half the steps on those, so we remove from them
  # anything that requires walking more than 65 steps in a section
  p = possibilities(input, 131).filter { _1[0] >= 0 && _1[0] < 131 && _1[1] >= 0 && _1[1] < 131 }

  odds = p.values.filter { |v| v.odd? && v > 65 }.count
  evens = p.values.filter { |v| v.even? && v > 65 }.count

  total - (sections + 1) * odds + sections * evens
end

def test
  example = %(...........
.....###.#.
.###.##..#.
..#.#...#..
....#.#....
.##..S####.
.##..#...#.
.......##..
.##.#.####.
.##..##.##.
...........)

  assert part_one(example, 6), 16
  0
end
