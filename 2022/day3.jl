using Test

function point(c)
    if 'a' <= c && c <= 'z'
        return c - 'a' + 1
    else # A..Z
        return c - 'A' + 27
    end
end

function part_one(input)
    rucksacks = split(input, "\n")
    return reduce((r, e) -> begin
            half = Int64(length(e) / 2)
            comp1, comp2 = e[1:half], e[half+1:end]
            return r + point(first(comp1 ∩ comp2))
        end, rucksacks; init=0)
end

function part_two(input)
    rucksacks = split(input, "\n")
    groups = Iterators.partition(rucksacks, 3)
    return reduce((r, e) -> r + point(first(intersect(e...))), groups; init=0)
    return 0
end

function test()
    example = """vJrwpWtwJgWrhcsFMMfFFhFp
jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
PmmdzqPrVvPwwTWBwg
wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
ttgJtRGJQctTZtZT
CrZsJsPPZsGzwwsLwLmpwMDw"""

    @test part_one(example) == 157
    @test part_two(example) == 70
end
