require './commons/assert'
require 'set'

def get_matches(cards)
  cards.map do |c|
    winning, mine = c.split(' | ').map { |ns| Set[*ns.split(' ').map(&:to_i)] }
    winning.intersection(mine).length
  end
end

def part_one(input)
  cards = input.split("\n").map { |c| c.split(': ')[1] }
  get_matches(cards).map { |m| m.zero? ? 0 : 2**(m - 1) }.sum
end

def part_two(input)
  cards = input.split("\n").map { |c| c.split(': ')[1] }
  matches = get_matches(cards).map { |c| [c, 1] } # idx -> matches, amount
  matches.each_with_index do |p, idx|
    ((idx + 1)..(idx + p[0])).each { |ni| matches[ni][1] += p[1] }
  end
  matches.map { |p| p[1] }.sum
end

def test
  example = %(Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11)

  assert part_one(example), 13
  assert part_two(example), 30
  0
end
