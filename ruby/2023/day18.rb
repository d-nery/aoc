require './commons/assert'

def solve(instr)
  points = [[0, 0]]
  curr = [0, 0]
  perimeter = 0

  instr.each do |i|
    case i[0]
    when 'R', '0'
      points << [curr[0], curr[1] + i[1]]
    when 'U', '3'
      points << [curr[0] - i[1], curr[1]]
    when 'L', '2'
      points << [curr[0], curr[1] - i[1]]
    when 'D', '1'
      points << [curr[0] + i[1], curr[1]]
    end
    curr = points[-1]
    perimeter += i[1]
  end

  area = 0
  j = points.length - 1
  points.length.times do |i|
    area += (points[j][0] + points[i][0]) * (points[j][1] - points[i][1])
    j = i
  end
  area = (area / 2).abs

  area + perimeter / 2 + 1
end

def part_one(input)
  instr = input.split("\n").map { [_1.split(' ')[0], _1.split(' ')[1].to_i] }
  solve(instr)
end

def part_two(input)
  instr = input.split("\n").map do |l|
    n = l[..-2].split('(#')[1]
    [n[-1], n[..4].to_i(16)]
  end
  solve(instr)
end

def test
  example = %{R 6 (#70c710)
D 5 (#0dc571)
L 2 (#5713f0)
D 2 (#d2c081)
R 2 (#59c680)
D 2 (#411b91)
L 5 (#8ceee2)
U 2 (#caa173)
L 1 (#1b58a2)
U 2 (#caa171)
R 2 (#7807d2)
U 3 (#a77fa3)
L 2 (#015232)
U 2 (#7a21e3)}

  assert part_one(example), 62
  assert part_two(example), 952_408_144_115
  0
end
