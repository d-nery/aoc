require './commons/assert'

def roots(t, d)
  # gambi: 0.000001 to not have integer results and round to next value cuase we want next integer
  [(-t + (t**2 - 4 * d)**0.5) / -2.0 + 0.00001, (-t - (t**2 - 4 * d)**0.5) / -2.0 - 0.000001]
end

def part_one(input)
  times, distances = input.split("\n").map { |s| s.split(':')[1].split(' ').map(&:to_i) }
  times.zip(distances).map do |race|
    from, to = roots(*race)
    to.floor - from.ceil + 1
  end.inject(:*)
end

def part_two(input)
  t, d = input.split("\n").map { |s| s.split(':')[1].gsub(' ', '').to_i }
  from, to = roots(t, d)
  to.floor - from.ceil + 1
end

def test
  example = %(Time:      7  15   30
Distance:  9  40  200)

  assert part_one(example), 288
  assert part_two(example), 71_503
  0
end
