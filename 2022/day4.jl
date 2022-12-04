using Test

function part_one(input)
    ranges = split.(split(input, "\n"), ",")
    overlaps = 0
    for r in ranges
        first = parse.(Int64, split(r[1], "-"))
        second = parse.(Int64, split(r[2], "-"))

        if (first[1] >= second[1] && first[2] <= second[2]) ||
           (second[1] >= first[1] && second[2] <= first[2])
            overlaps += 1
        end
    end
    return overlaps
end

function part_two(input)
    ranges = split.(split(input, "\n"), ",")
    overlaps = 0
    for r in ranges
        first = parse.(Int64, split(r[1], "-"))
        second = parse.(Int64, split(r[2], "-"))

        if second[1] <= first[1] <= second[2] ||
           second[1] <= first[2] <= second[2] ||
           first[1] <= second[1] <= first[2]
            overlaps += 1
        end
    end
    return overlaps
end

function test()
    example = """2-4,6-8
2-3,4-5
5-7,7-9
2-8,3-7
6-6,4-6
2-6,4-8"""

    @test part_one(example) == 2
    @test part_two(example) == 4
end
