using Test

function part_one(input)
    raw_grid = split.(split(input, "\n"), "")
    grid = parse.(Int64, mapreduce(permutedims, vcat, raw_grid))

    x, y = size(grid)

    visible = 2x + 2y - 4

    for i in 2:x-1
        for j in 2:y-1
            if all(grid[1:i-1, j] .< grid[i, j]) ||
               all(grid[i+1:end, j] .< grid[i, j]) ||
               all(grid[i, 1:j-1] .< grid[i, j]) ||
               all(grid[i, j+1:end] .< grid[i, j])
                visible += 1
            end
        end
    end

    return visible
end

function part_two(input)
    raw_grid = split.(split(input, "\n"), "")
    grid = parse.(Int64, mapreduce(permutedims, vcat, raw_grid))

    x, y = size(grid)

    highest_score = 0

    for i in 2:x-1
        for j in 2:y-1
            # left
            l = 0
            for e in grid[i, j-1:-1:1]
                l += 1
                if e >= grid[i, j]
                    break
                end
            end
            # right
            r = 0
            for e in grid[i, j+1:end]
                r += 1
                if e >= grid[i, j]
                    break
                end
            end
            # up
            u = 0
            for e in grid[i-1:-1:1, j]
                u += 1
                if e >= grid[i, j]
                    break
                end
            end

            # down
            d = 0
            for e in grid[i+1:end, j]
                d += 1
                if e >= grid[i, j]
                    break
                end
            end
            highest_score = max(highest_score, l * u * r * d)
        end
    end

    return highest_score
end

function test()
    example = """30373
25512
65332
33549
35390"""

    @test part_one(example) == 21
    @test part_two(example) == 8
end
