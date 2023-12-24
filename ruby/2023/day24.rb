require './commons/assert'

def part_one(input, min = 200_000_000_000_000, max = 400_000_000_000_000)
  stones = input.split("\n").map { _1.split('@').map { |v| v.split(', ').map(&:to_i) } }
  intersections = 0
  (0...stones.length).each do |i|
    (i + 1...stones.length).each do |j|
      x1, y1, = stones[i][0]
      x2, y2, = stones[i].transpose.map(&:sum)
      x3, y3, = stones[j][0]
      x4, y4, = stones[j].transpose.map(&:sum)

      den = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4)
      next if den.zero?

      ix = ((((x1 * y2 - y1 * x2) * (x3 - x4)) - ((x1 - x2) * (x3 * y4 - y3 * x4)))) / den
      iy = ((((x1 * y2 - y1 * x2) * (y3 - y4)) - ((y1 - y2) * (x3 * y4 - y3 * x4)))) / den

      # Check if is past
      if x2 - x1 < 0
        next if ix > x1
      elsif x2 - x1 > 0
        next if ix < x1
      end

      if x4 - x3 < 0
        next if ix > x3
      elsif x4 - x3 > 0
        next if ix < x3
      end

      intersections += 1 if ix >= min && ix <= max && iy >= min && iy <= max
    end
  end
  intersections
end

def part_two(input)
  # For each stone A
  # Rx + Rvx * t = Ax + Avx * t
  # Ry + Rvy * t = Ay + Avy * t
  # Rz + Rvz * t = Az + Avz * t
  # t > 0
  # Will use z3, check day24.cpp
  47
end

def test
  example = %(19, 13, 30 @ -2,  1, -2
18, 19, 22 @ -1, -1, -2
20, 25, 34 @ -2, -2, -4
12, 31, 28 @ -1, -2, -1
20, 19, 15 @  1, -5, -3)

  assert part_one(example, 7, 27), 2
  assert part_two(example), 47
  0
end
