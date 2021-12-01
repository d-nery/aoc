using Test

function part_one(input, window=1)
    numbers = parse.(Int64, split(input, "\n"))
    windows = sum.(numbers[i:i+window-1] for i in 1:length(numbers)-window+1)
    return sum(windows[2:end] .> windows[1:end-1])
end

function part_two(input)
    return part_one(input, 3)
end

function test()
    example = """199
200
208
210
200
207
240
269
260
263"""

    @test part_one(example) == 7
    @test part_two(example) == 5
end
