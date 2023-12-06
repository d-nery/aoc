require './commons/assert'

def dist(total, held)
  held * (total - held)
end

def part_one(input)
  times, distances = input.split("\n").map { |s| s.split(':')[1].split(' ').map(&:to_i) }
  races = times.zip(distances)
  races.map do |race|
    t, d = race
    (0..t).map { |held| dist(t, held) }.filter { |x| x > d }.count
  end.inject(:*)
end

def part_two(input)
  t, d = input.split("\n").map { |s| s.split(':')[1].gsub(' ', '').to_i }
  (0..t).map { |held| dist(t, held) }.filter { |x| x > d }.count
end

def test
  example = %(Time:      7  15   30
Distance:  9  40  200)

  assert part_one(example), 288
  assert part_two(example), 71_503
  0
end
