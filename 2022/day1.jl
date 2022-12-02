using Test

function part_one(input)
    elves = split.(split(input, "\n\n"), "\n")
    per_elf = map(e -> sum(parse.(Int64, e)), elves)
    return maximum(per_elf)
end

function part_two(input)
    elves = split.(split(input, "\n\n"), "\n")
    per_elf = map(e -> sum(parse.(Int64, e)), elves)
    return sum(sort(per_elf)[end-2:end])
end

function test()
    example = """1000
2000
3000

4000

5000
6000

7000
8000
9000

10000"""

    @test part_one(example) == 24000
    @test part_two(example) == 45000
end
