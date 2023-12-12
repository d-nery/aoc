require 'memoist'
require './commons/assert'

def get_all_possibilities(size, n)
  groups = n.length
  empty = size - n.sum
  (0..empty).to_a.combination(groups).map do |c|
    p = '.' * size
    idx = c[0]
    n.each_with_index do |group, i|
      p[idx...idx + group] = '#' * group
      idx += group + (c[i + 1] || 0) - c[i]
    end
    p
  end
end

def arrangements(s, n)
  size = s.length
  possibilities = get_all_possibilities(size, n)
  re = Regexp.new s.gsub('.', 'x').gsub('?', '[#.]').gsub('x', '\.')
  possibilities.filter { |p| re.match? p }.length
end

# Part 2 will need a recursive approach with memoization, restarting ;-;
@counts = {}
def _count(line, groups)
  @counts["#{line.hash}, #{groups.hash}"] ||= count(line, groups)
end

def count(line, groups)
  # Processed everything -> valid
  return 1 if line.empty? && groups.empty?

  # Finished line but still have groups -> invalid
  return 0 if line.empty?

  case line[0]
  when '.'
    # We can ignore dots and process the rest
    _count(line[1..], groups)
  when '?'
    # For ? we check if it's valid with dot and #
    _count(line.sub('?', '.'), groups) + _count(line.sub('?', '#'), groups)
  when '#'
    # finished processing groups but still have # or we have less possible #s than this group needs -> invalid
    return 0 if groups.empty? || line.length < groups[0]

    # there's a dot not allowing the full group of #s -> invalid
    return 0 if line[...groups[0]].chars.any? { |c| c == '.' }

    # This group is valid and the last one, keep processing to check if the rest of the line is valid (only dots and ?s)
    return _count(line[groups[0]..], groups[1..]) if groups.length == 1

    # Not enough or more #s than this group allows -> invalid
    return 0 if line.length <= groups[0] || line[groups[0]] == '#'

    # This group is valid, process next one without current
    # Next character must be a "." (even if it is a "?") so we skip it
    _count(line[groups[0] + 1..], groups[1..])
  else
    raise '💀'
  end
end

def unfolded_arrangements(s, n)
  _count(([s] * 5).join('?'), n * 5)
end

def part_one(input)
  springs = input.split("\n").map { _1.split(' ') }.map { [_1, _2.split(',').map(&:to_i)] }
  springs.map { arrangements(_1, _2) }.sum
end

def part_two(input)
  springs = input.split("\n").map { _1.split(' ') }.map { [_1, _2.split(',').map(&:to_i)] }
  springs.map { unfolded_arrangements(_1, _2) }.sum
end

def test
  example = %(???.### 1,1,3
.??..??...?##. 1,1,3
?#?#?#?#?#?#?#? 1,3,1,6
????.#...#... 4,1,1
????.######..#####. 1,6,5
?###???????? 3,2,1)

  assert part_one(example), 21
  assert part_two(example), 525_152
  0
end
