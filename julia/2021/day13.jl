using Test

function get_folded_grid(input, fold_all = true)
    (dots, instructions) = split(input, "\n\n")
    instr_pat = r"^fold along ([xy])=(\d+)$"

    dots = map(s -> parse.(Int, s) .+ 1, split.(split(dots, "\n"), ","))
    instructions = split(instructions, "\n")

    max_y = max(map(n -> n[1], dots)...)
    max_x = max(map(n -> n[2], dots)...)

    grid = zeros(Int8, max_x, max_y)

    for (y, x) in dots
        grid[x, y] |= 1
    end

    for instr in instructions[1:(fold_all ? end : 1)]
        (ax, n) = match(instr_pat, instr).captures
        n = parse(Int, n) + 1

        if ax == "x"
            dy = max_y - n
            grid[:, end-2dy:end-dy-1] .|= grid[:, end:-1:end-dy+1]
            grid = grid[:, 1:end-dy-1]
            max_y -= dy - 1
        else
            dx = max_x - n
            grid[end-2dx:end-dx-1, :] .|= grid[end:-1:end-dx+1, :]
            grid = grid[1:end-dx-1, :]
        end
        (max_x, max_y) = size(grid)
    end

    return grid
end

function part_one(input)
    grid = get_folded_grid(input, false)
    return sum(grid)
end

function part_two(input)
    grid = get_folded_grid(input)
    grid = map(s -> s == 1 ? "#" : ".", grid)
    for g in eachrow(grid)
        println(join(g, " "))
    end
    return 0
end

function test()
    example = """6,10
0,14
9,10
0,3
10,4
4,11
6,0
6,12
4,1
0,13
10,12
3,4
3,0
8,4
1,10
2,14
8,10
9,0

fold along y=7
fold along x=5"""

    @test part_one(example) == 17
    @test part_two(example) == 0
end
