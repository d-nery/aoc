require './commons/assert'

$card_points = {
  'A' => 13,
  'K' => 12,
  'Q' => 11,
  'J' => 10,
  'T' => 9,
  '9' => 8,
  '8' => 7,
  '7' => 6,
  '6' => 5,
  '5' => 4,
  '4' => 3,
  '3' => 2,
  '2' => 1
}

$card_points_joker = {
  'A' => 13,
  'K' => 12,
  'Q' => 11,
  'J' => 0,
  'T' => 9,
  '9' => 8,
  '8' => 7,
  '7' => 6,
  '6' => 5,
  '5' => 4,
  '4' => 3,
  '3' => 2,
  '2' => 1
}

def parse_hand(hand)
  cards = hand.split('')
  card_count = cards.tally
  points = if card_count.any? { |x| x[1] == 5 }
             [7]
           elsif card_count.any? { |x| x[1] == 4 }
             [6]
           elsif card_count.any? { |x| x[1] == 3 } && card_count.any? { |x| x[1] == 2 }
             [5]
           elsif card_count.any? { |x| x[1] == 3 }
             [4]
           elsif card_count.filter { |_, v| v == 2 }.count == 2
             [3]
           elsif card_count.any? { |x| x[1] == 2 }
             [2]
           else
             [1]
           end

  points + cards.map { |c| $card_points[c] }
end

def parse_hand_joker(hand)
  cards = hand.split('')
  card_count = cards.tally
  jokers = card_count['J'] || 0
  card_count['J'] = 0
  points = if card_count.any? { |x| x[1] == 5 } || card_count.any? { |x| x[1] == 5 - jokers }
             [7]
           elsif card_count.any? { |x| x[1] == 4 } || card_count.any? { |x| x[1] == 4 - jokers }
             [6]
           elsif (card_count.filter { |_, v| v == 2 }.count == 2 && jokers == 1) ||
                 (card_count.any? { |x| x[1] == 3 } && card_count.any? { |x| x[1] == 2 })
             [5]
           elsif card_count.any? { |x| x[1] == 3 } || card_count.any? { |x| x[1] == 3 - jokers }
             [4]
           elsif card_count.filter { |_, v| v == 2 }.count == 2
             [3]
           elsif card_count.any? { |x| x[1] == 2 } || card_count.any? { |x| x[1] == 2 - jokers }
             [2]
           else
             [1]
           end

  points + cards.map { |c| $card_points_joker[c] }
end

def part_one(input)
  hands = input.split("\n").map { |x| x.split(' ') }
  sorted = hands.sort do |h1, h2|
    p1 = parse_hand(h1[0])
    p2 = parse_hand(h2[0])
    p1 <=> p2
  end
  sorted.each_with_index.map { |s, i| s[1].to_i * (i + 1) }.sum
end

def part_two(input)
  hands = input.split("\n").map { |x| x.split(' ') }
  sorted = hands.sort do |h1, h2|
    p1 = parse_hand_joker(h1[0])
    p2 = parse_hand_joker(h2[0])
    p1 <=> p2
  end
  sorted.each_with_index.map { |s, i| s[1].to_i * (i + 1) }.sum
end

def test
  example = %(32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483)

  assert part_one(example), 6440
  assert part_two(example), 5905
  0
end
