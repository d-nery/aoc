using Test
using Statistics

function summ(x)
    return x * (x + 1) / 2
end

function part_one(input)
    positions = parse.(Int, split(input, ","))
    target = median(positions)

    moves = abs.(positions .- target)

    return sum(moves)
end

function part_two(input)
    positions = parse.(Int, split(input, ","))

    m = max(positions...)
    minor = Inf64
    for i = 1:m
        moves = sum(summ.(abs.(positions .- i)))
        minor = min(minor, sum(moves))
    end

    return Int64(minor)
end

function test()
    example = """16,1,2,0,4,2,7,1,2,14"""

    @test part_one(example) == 37
    @test part_two(example) == 168
end
