using Test

function part_one(input, distinct=4)
    input = strip(input)
    seq = input[1:distinct]
    idx = distinct

    while (!allunique(seq))
        idx += 1
        seq *= input[idx]
        seq = seq[2:end]
    end

    return idx
end

function part_two(input)
    return part_one(input, 14)
end

function test()
    example1 = """mjqjpqmgbljsphdztnvjfqwrcgsmlb"""
    example2 = """bvwbjplbgvbhsrlpgdmjqwftvncz"""
    example3 = """nppdvjthqldpwncqszvftbrmjlhg"""
    example4 = """nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg"""
    example5 = """zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw"""

    @test part_one(example1) == 7
    @test part_one(example2) == 5
    @test part_one(example3) == 6
    @test part_one(example4) == 10
    @test part_one(example5) == 11
    @test part_two(example1) == 19
    @test part_two(example2) == 23
    @test part_two(example3) == 23
    @test part_two(example4) == 29
    @test part_two(example5) == 26
end
