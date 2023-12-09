require './commons/assert'

def process(input, add_op, idx_to_check)
  sequences = input.split("\n").map { |l| l.split(' ').map(&:to_i) }
  sequences.map do |seq|
    s = [seq]
    until s[-1].all?(&:zero?)
      last = s[-1]
      s << last[1..].each_with_index.map { |e, i| e - last[i] }
    end

    s.reverse!
    s[..-2].each_with_index do |_, i|
      add_op.call(s, i)
    end

    s[-1][idx_to_check]
  end.sum
end

def part_one(input)
  process(input, ->(s, i) { s[i + 1] << (s[i][-1] + s[i + 1][-1]) }, -1)
end

def part_two(input)
  process(input, ->(s, i) { s[i + 1].unshift(s[i + 1][0] - s[i][0]) }, 0)
end

def test
  example = %(0 3 6 9 12 15
1 3 6 10 15 21
10 13 16 21 30 45)

  assert part_one(example), 114
  assert part_two(example), 2
  0
end
