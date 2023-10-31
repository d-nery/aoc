# frozen_string_literal: true

require 'set'
require './commons/assert'

def part_one(input)
  input.split("\n").map(&:to_i).sum
end

def part_two(input)
  freqs = input.split("\n").map(&:to_i)
  current = 0
  found = Set[0]

  loop do
    freqs.each do |f|
      current += f
      return current if found.include?(current)

      found.add(current)
    end
  end
end

def test
  example = %(+1
-2
+3
+1)

  assert part_one(example), 3
  assert part_two(example), 2
  0
end
