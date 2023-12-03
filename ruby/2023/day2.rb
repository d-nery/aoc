require './commons/assert'

def part_one(input)
  max_red = 12
  max_green = 13
  max_blue = 14

  games = input.split("\n")

  games.each_with_index.map do |g, i|
    next 0 if g.scan(/(\d+) red/).map { |m| m[0].to_i }.any? { |n| n > max_red }
    next 0 if g.scan(/(\d+) green/).map { |m| m[0].to_i }.any? { |n| n > max_green }
    next 0 if g.scan(/(\d+) blue/).map { |m| m[0].to_i }.any? { |n| n > max_blue }

    next i + 1
  end.sum
end

def part_two(input)
  games = input.split("\n")
  games.map do |g, _i|
    reds = g.scan(/(\d+) red/).map { |m| m[0].to_i }
    greens = g.scan(/(\d+) green/).map { |m| m[0].to_i }
    blues = g.scan(/(\d+) blue/).map { |m| m[0].to_i }

    reds.max * greens.max * blues.max
  end.sum
end

def test
  example = %(Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green)

  assert part_one(example), 8
  assert part_two(example), 2286
  0
end
