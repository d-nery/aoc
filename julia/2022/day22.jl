using Test
using CircularArrays
using Images
using Printf
using FileIO

function dump(field, player, dir)
    print("\e[2J")
    grid = map(s -> s == 1 ? "🟩" : s == 0 ? "🟫" : s == 3 ? "🟦" : "🟥", field)
    if dir == (0, 1)
        grid[player...] = "⏩"
    elseif dir == (0, -1)
        grid[player...] = "⏪"
    elseif dir == (1, 0)
        grid[player...] = "⏬"
    else
        grid[player...] = "⏫"
    end

    for g in eachrow(grid)
        println(join(g, ""))
    end
    println()
    readline()
end

function to_img(grid, i)
    img = map(n ->
            n == 0 ? RGB(0.0, 0.0, 0.0) :
            n == 1 ? RGB(0.0, 1.0, 0.0) :
            n == 2 ? RGB(1.0, 0.0, 0.0) :
            RGB(0.0, 0.0, 1.0), grid)
    FileIO.save("vis/test$(@sprintf("%06d", i)).png", img)
end

function parse_input(input)
    (map, instr) = split(input, "\n\n")
    map = split.(split(map, "\n"), "")
    h = size(map)[1]
    w = maximum(size.(map))[1]
    m = zeros(Int, (h, w))

    for (x, row) in enumerate(map)
        for (y, char) in enumerate(row)
            m[x, y] = char == " " ? 0 : char == "." ? 1 : 2
        end
    end

    instr = [m.match for m in eachmatch(r"(\d+|[RL])", instr)]

    return (m, instr)
end

function part_one(input)
    (map, instructions) = parse_input(input)
    (h, w) = size(map)

    directions = CircularArray([(1, 0), (0, 1), (-1, 0), (0, -1)])

    pos = (1, findfirst(x -> x == 1, map[1, 1:end]))
    dir = 2

    # dump(map, pos, directions[dir])
    for instr in instructions
        # println(instr)
        if instr == "R"
            dir -= 1
            # dump(map, pos, directions[dir])
        elseif instr == "L"
            dir += 1
            # dump(map, pos, directions[dir])
        else
            n = parse(Int, instr)
            for i in 1:n
                # dump(map, pos, directions[dir])
                next_pos = pos .+ directions[dir]
                if next_pos[1] <= 0 || (directions[dir][1] == -1 && map[next_pos...] == 0)
                    x = findlast(p -> p != 0, map[1:end, next_pos[2]])
                    next_pos = (x, next_pos[2])
                elseif next_pos[1] > h || (directions[dir][1] == 1 && map[next_pos...] == 0)
                    x = findfirst(p -> p != 0, map[1:end, next_pos[2]])
                    next_pos = (x, next_pos[2])
                elseif next_pos[2] <= 0 || (directions[dir][2] == -1 && map[next_pos...] == 0)
                    y = findlast(p -> p != 0, map[next_pos[1], 1:end])
                    next_pos = (next_pos[1], y)
                elseif next_pos[2] > w || (directions[dir][2] == 1 && map[next_pos...] == 0)
                    y = findfirst(p -> p != 0, map[next_pos[1], 1:end])
                    next_pos = (next_pos[1], y)
                end

                # wall
                if map[next_pos...] == 2
                    break
                end

                pos = next_pos
            end
        end
        # dump(map, pos, directions[dir])
    end

    d = directions[dir]
    return 1000 * pos[1] + 4 * pos[2] +
           (d == (0, 1) ? 0 : d == (1, 0) ? 1 : d == (0, -1) ? 2 : 3)
end

function part_two(input, s=50)
    (map, instructions) = parse_input(input)
    (h, w) = size(map)

    directions = CircularArray([(1, 0), (0, 1), (-1, 0), (0, -1)])
    DOWN = 1
    RIGHT = 2
    UP = 3
    LEFT = 4

    pos = (1, findfirst(x -> x == 1, map[1, 1:end]))
    dir = 2

    img = 0

    map[pos...] = 3

    # dump(map, pos, directions[dir])grid[player...]
    # to_img(map, img)
    # img += 1

    # dump(map, pos, directions[dir])
    for instr in instructions
        # println(instr)
        # dump(map, pos, directions[dir])
        if instr == "R"
            dir -= 1
            # dump(map, pos, directions[dir])
        elseif instr == "L"
            dir += 1
            # dump(map, pos, directions[dir])
        else
            n = parse(Int, instr)
            for i in 1:n
                next_pos = pos .+ directions[dir]
                next_dir = dir

                # Dividing input in sections
                # [ 1][ 2][ 3]
                # [ 4][ 5][ 6]
                # [ 7][ 8][ 9]
                # [10][11][12]
                # My input has the cube on 2 3 5 7 8 10
                sections = [((1, 51), (50, 100)), ((1, 101), ())]


                if directions[dir] == (1, 0)  # down
                    if next_pos[1] > 50 && next_pos[2] > 100 # 3 -> 5 from right
                        next_dir = LEFT
                        next_pos = (next_pos[2] - 50, 100)
                    elseif next_pos[1] > 150 && 50 < next_pos[2] <= 100 # 8 -> 10 from right
                        next_dir = LEFT
                        next_pos = (100 + next_pos[2], 50)
                    elseif next_pos[1] > 200 && next_pos[2] <= 50 # 10 -> 3 from top
                        next_dir = DOWN
                        next_pos = (1, next_pos[2] + 100)
                    end
                elseif directions[dir] == (0, 1)  # right
                    if next_pos[1] <= 50 && next_pos[2] > 150 # 3 -> 8 from right
                        next_dir = LEFT
                        next_pos = (151 - next_pos[1], 100)
                    elseif 50 < next_pos[1] <= 100 && next_pos[2] > 100 # 5 -> 3 from bottom
                        next_dir = UP
                        next_pos = (50, 50 + next_pos[1])
                    elseif 100 < next_pos[1] <= 150 && next_pos[2] > 100 # 8 -> 3 from right
                        next_dir = LEFT
                        next_pos = (151 - next_pos[1], 150)
                    elseif 150 < next_pos[1] <= 200 && next_pos[2] > 50 # 10 -> 8 from bottom
                        next_dir = UP
                        next_pos = (150, next_pos[1] - 100)
                    end
                elseif directions[dir] == (-1, 0) # up
                    if next_pos[1] <= 0 && next_pos[2] <= 100 # 2 -> 10 from left
                        next_dir = RIGHT
                        next_pos = (100 + next_pos[2], 1)
                    elseif next_pos[1] <= 0 && next_pos[2] > 100 # 3 -> 10 from bottom
                        next_dir = UP
                        next_pos = (200, next_pos[2] - 100)
                    elseif next_pos[1] <= 100 && next_pos[2] <= 50 # 7 -> 5 from left
                        next_dir = RIGHT
                        next_pos = (50 + next_pos[2], 51)
                    end
                else # left
                    if next_pos[1] <= 50 && next_pos[2] <= 50 # 2 -> 7 from left
                        next_dir = RIGHT
                        next_pos = (151 - next_pos[1], 1)
                    elseif 50 < next_pos[1] <= 100 && next_pos[2] <= 50 # 5 -> 7 from top
                        next_dir = DOWN
                        next_pos = (101, next_pos[1] - 50)
                    elseif 100 < next_pos[1] <= 150 && next_pos[2] <= 0 # 7 -> 2 from left
                        next_dir = RIGHT
                        next_pos = (151 - next_pos[1], 51)
                    elseif 150 < next_pos[1] <= 200 && next_pos[2] <= 0 # 10 -> 2 from top
                        next_dir = DOWN
                        next_pos = (1, next_pos[1] - 100)
                    end
                end

                # wall
                if map[next_pos...] == 2
                    break
                end

                pos = next_pos
                dir = next_dir

                map[pos...] = 3

                # dump(map, pos, directions[dir])grid[player...]
                # to_img(map, img)
                # img += 1
            end
        end
        # dump(map, pos, directions[dir])
    end

    d = directions[dir]
    return 1000 * pos[1] + 4 * pos[2] +
           (d == (0, 1) ? 0 : d == (1, 0) ? 1 : d == (0, -1) ? 2 : 3)
end

function test()
    example = """        ...#
        .#..
        #...
        ....
...#.......#
........#...
..#....#....
..........#.
        ...#....
        .....#..
        .#......
        ......#.

10R5L5R10L4R5L5"""

    @test part_one(example) == 6032
    # @test part_two(example) == 5031
end
