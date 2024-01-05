require './commons/assert'

def brick_at_pos(bricks, x, y, z)
  bricks.each_with_index do |b, i|
    return i.to_s if b[0][0] <= x && x <= b[1][0] && b[0][1] <= y && y <= b[1][1] && b[0][2] <= z && z <= b[1][2]
  end
  return '-' if z.zero?

  '.'
end

def fall(bricks)
end

def part_one(input)
  bricks = input.split("\n").map { _1.split('~') }
                .map { [_1.split(',').map(&:to_i), _2.split(',').map(&:to_i)] }
                .sort { |b1, b2| b1[1][2] <=> b2[1][2] }

  min_x = bricks.map { [_1[0][0], _1[1][0]].min }.min
  max_x = bricks.map { [_1[0][0], _1[1][0]].max }.max

  min_y = bricks.map { [_1[0][1], _1[1][1]].min }.min
  max_y = bricks.map { [_1[0][1], _1[1][1]].max }.max

  max_z = bricks.map { [_1[0][2], _1[1][2]].max }.max

  (min_y..max_y).each do |y|
    puts "y = #{y}"
    max_z.downto(0) do |z|
      (min_x..max_x).each do |x|
        printf "#{brick_at_pos(bricks, x, y, z)}"
      end
      printf("\n")
    end
  end
  0
end

def part_two(input)
  0
end

def test
  example = %(1,0,1~1,2,1
0,0,2~2,0,2
0,2,3~2,2,3
0,0,4~0,2,4
2,0,5~2,2,5
0,1,6~2,1,6
1,1,8~1,1,9)

  assert part_one(example), 5
  assert part_two(example), 0
  0
end
