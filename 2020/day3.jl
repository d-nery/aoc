using Test

function at(arr, idx)
    return arr[((idx-1)%length(arr))+1]
end

function part_one(input, direction = [3, 1])
    map = split.(split(input, "\n"), "")
    col = 1
    return reduce((v, row) -> begin
            v += at(row, col) == "#" ? 1 : 0
            col += direction[1]
            return v
        end, map[((1:end).-1).%direction[2].==0]; init = 0)
end

function part_two(input)
    return prod(map(f -> part_one(input, f), [[1, 1], [3, 1], [5, 1], [7, 1], [1, 2]]))
end

function test()
    example = """..##.......
#...#...#..
.#....#..#.
..#.#...#.#
.#...##..#.
..#.##.....
.#.#.#....#
.#........#
#.##...#...
#...##....#
.#..#...#.#"""

    @test part_one(example) == 7
    @test part_two(example) == 336
end
