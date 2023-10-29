using Test
using DataStructures

function part_one(input, days = 80)
    fish = parse.(Int, split(input, ","))
    c = counter(fish)

    for _day = 1:days
        zeros = c[0]
        for i = 0:7
            c[i] = c[i+1]
        end
        c[6] += zeros
        c[8] = zeros
    end

    return sum(c)
end

function part_two(input)
    return part_one(input, 256)
end

function test()
    example = """3,4,3,1,2"""

    @test part_one(example) == 5934
    @test part_two(example) == 26984457539
end
