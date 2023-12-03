require './commons/assert'

def neighbours(x, y, s, max_x, max_y)
  neighb = (y - 1..y + s).map { |n| [x - 1, n] }
  neighb << [x, y - 1]
  neighb << [x, y + s]
  neighb += (y - 1..y + s).map { |n| [x + 1, n] }
  neighb.filter { |n| n[0] >= 0 && n[0] < max_x && n[1] >= 0 && n[1] < max_y }
end

def process(lines)
  lines.each_with_index do |l, i|
    numbers = l.scan(/\d+/)
    numbers.each do |n|
      number = n.to_i
      idx = l.index n
      size = n.length

      # Remove already parsed numbers so repeated numbers in the same line can be found
      l.sub! n, '.' * size

      neighbours(i, idx, size, lines.size, l.size).each do |neigh|
        yield neigh, number
      end
    end
  end
end

def part_one(input)
  lines = input.split("\n")
  sum = 0

  process(lines) do |neigh, number|
    c = lines[neigh[0]][neigh[1]]
    next unless c != '.' && (c.ord < '0'.ord || c.ord > '9'.ord)

    sum += number
  end

  sum
end

def part_two(input)
  lines = input.split("\n")
  gears = {}

  process(lines) do |neigh, number|
    c = lines[neigh[0]][neigh[1]]
    if c == '*'
      if gears.key?(neigh)
        gears[neigh] << number
      else
        gears[neigh] = [number]
      end
    end
  end

  gears.map { |g| g[1].length == 2 ? g[1][0] * g[1][1] : 0 }.sum
end

def test
  example = %(467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592..20.
......755.
...$.*....
.664.598..)

  assert part_one(example), 4361
  assert part_two(example), 467_835
  0
end
