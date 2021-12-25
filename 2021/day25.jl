using Test
using Images
using FileIO
using Printf

function step(grid)
    sx, sy = length(grid), length(grid[1])
    s1 = deepcopy(grid)

    for i = 1:sx
        for j = 1:sy
            if s1[i][j] != ">"
                continue
            end

            nj = (j == sy) ? 1 : j + 1

            if s1[i][nj] == "."
                grid[i][j] = "."
                grid[i][nj] = ">"
            end
        end
    end

    s2 = deepcopy(grid)

    for i = 1:sx
        for j = 1:sy
            if s2[i][j] != "v"
                continue
            end

            ni = (i == sx) ? 1 : i + 1

            if s2[ni][j] == "."
                grid[i][j] = "."
                grid[ni][j] = "v"
            end
        end
    end

    return any(grid .!= s1)
end

function dump(grid)
    println(join(map(join, grid), "\n"))
end

function display(grid, n)
    img = map.(n -> n == "." ? RGB(1.0, 1.0, 1.0) : n == ">" ? RGB(1.0, 0.0, 0.0) : RGB(0.8, 0.0, 0.0), grid)
    FileIO.save("vis/test$(@sprintf("%03d", n)).png", transpose(hcat(img...)))
end

function part_one(input)
    grid = split.(split(input, "\n"), "")
    iters = 1

    while step(grid)
        iters += 1

        println("Step $iters")
        display(grid, iters)
        # dump(grid)
    end

    return iters
end

function part_two(input)
    return 0
end

function test()
    example = """v...>>.vv>
.vv>>.vv..
>>.>v>...v
>>v>>.>.v.
v>v.vv.v..
>.>>..v...
.vv..>.>v.
v.v..>>v.v
....v..v.>"""

    @test part_one(example) == 58
    # @test part_two(example) == 0
end
