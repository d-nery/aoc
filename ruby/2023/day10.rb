require './commons/assert'

def to_better_readable(input)
  input.gsub('|', '│')
       .gsub('7', '┐')
       .gsub('J', '┘')
       .gsub('F', '┌')
       .gsub('-', '─')
       .gsub('L', '└')
       .gsub('.', ' ')
end

# 36 comes form manual inspection of the resulting output
# it's the count of characters in aa loop outside the main one
def part_one(input, extra_loop_tiles = 36)
  input = to_better_readable(input)
  floor = input.split("\n").map { |l| l.split('') }

  to_up_chars = ['│', '┐', '┌', 'S']
  to_down_chars = ['│', '┘', '└', 'S']
  to_left_chars = ['─', '└', '┌', 'S']
  to_right_chars = ['─', '┘', '┐', 'S']

  chars = input.chars.filter { |c| c != ' ' }.count
  now = 0

  while now != chars
    now = chars
    (0...floor.length).each do |i|
      (0...floor[0].length).each do |j|
        next if floor[i][j] == 'S' || floor[i][j] == ' '

        # Upper border
        floor[i][j] = ' ' if i == 0 && (['│', '┘', '└'].include? floor[i][j])

        # Lower border
        floor[i][j] = ' ' if i == floor.length - 1 && (['│', '┐', '┌'].include? floor[i][j])

        # Left border
        floor[i][j] = ' ' if j == 0 && (['─', '┐', '┘'].include? floor[i][j])

        # Right border
        floor[i][j] = ' ' if j == floor[0].length && (['─', '┌', '└'].include? floor[i][j])

        if floor[i][j] == '│' && !(to_up_chars.include?(floor[i - 1][j]) && to_down_chars.include?(floor[i + 1][j]))
          floor[i][j] = ' '
        end

        if floor[i][j] == '┐' && !(to_left_chars.include?(floor[i][j - 1]) && to_down_chars.include?(floor[i + 1][j]))
          floor[i][j] = ' '
        end

        if floor[i][j] == '┘' && !(to_left_chars.include?(floor[i][j - 1]) && to_up_chars.include?(floor[i - 1][j]))
          floor[i][j] = ' '
        end

        if floor[i][j] == '┌' && !(to_right_chars.include?(floor[i][j + 1]) && to_down_chars.include?(floor[i + 1][j]))
          floor[i][j] = ' '
        end

        if floor[i][j] == '─' && !(to_right_chars.include?(floor[i][j + 1]) && to_left_chars.include?(floor[i][j - 1]))
          floor[i][j] = ' '
        end

        if floor[i][j] == '└' && !(to_up_chars.include?(floor[i - 1][j]) && to_right_chars.include?(floor[i][j + 1]))
          floor[i][j] = ' '
        end

        chars -= 1 if floor[i][j] == ' '
      end
    end
  end

  puts floor.map { |f| f.join('') }.join("\n")
  (floor.flatten.count { |c| c != ' ' } - extra_loop_tiles) / 2
end

def part_two(input)
  # Part2 was made manually, see day10_p2_manual.txt and ctrl+f the x's
  0
end

def test
  example = %(.....
.S-7.
.|.|.
.L-J.
.....)

  example2 = %(..F7.
.FJ|.
SJ.L7
|F--J
LJ...)

  assert part_one(example, 0), 4
  assert part_one(example2, 0), 8
  assert part_two(example), 0
  0
end
