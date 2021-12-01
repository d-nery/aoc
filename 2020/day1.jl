using Combinatorics
using Test

function part_one(input, comb = 2)
    numbers = parse.(Int64, split(input, "\n"))
    return prod(first(Iterators.filter(f -> sum(f) == 2020, combinations(numbers, comb))))
end

function part_two(input)
    return part_one(input, 3)
end

function test()
    example = """1721
979
366
299
675
1456"""

    @test part_one(example) == 514579
    @test part_two(example) == 241861950
end
