require './commons/assert'

def part_one(input)
  inputs = input.split("\n").map { |c| c.split('').select { |c| c.ord >= 48 && c.ord <= 57 } }
  inputs.map { |i| (i[0] + i[-1]).to_i }.sum
end

def part_two(input)
  # avoid two numbers mashed together being incorrectly replaced, like eightwo should be 82
  # eightwo => eightwo2two => eight8eightwo2two which will be correctly interpreted
  input.gsub! 'one', 'one1one'
  input.gsub! 'two', 'two2two'
  input.gsub! 'three', 'three3three'
  input.gsub! 'four', 'four4four'
  input.gsub! 'five', 'five5five'
  input.gsub! 'six', 'six6six'
  input.gsub! 'seven', 'seven7seven'
  input.gsub! 'eight', 'eight8eight'
  input.gsub! 'nine', 'nine9nine'

  part_one(input)
end

def test
  example = %(1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet)

  example2 = %(two1nine
eightwothree
abcone2threexyz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen)

  assert part_one(example), 142
  assert part_two(example2), 281
  0
end
