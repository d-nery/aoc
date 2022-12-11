using Test

const strength = (cycle, X) -> cycle * X

function part_one(input)
    instructions = split(input, "\n")
    X = 1
    cycles = 1
    ans = 0

    inc_cycle = () -> begin
        cycles += 1
        if (cycles ∈ [20, 60, 100, 140, 180, 220])
            ans += strength(cycles, X)
        end
    end

    for instr in instructions
        if instr == "noop"
            inc_cycle()
            continue
        end

        inc_cycle()
        X += parse(Int64, split(instr, " ")[2])
        inc_cycle()
    end

    return ans
end

function part_two(input)
    instructions = split(input, "\n")
    X = 1
    CRT = 0
    raw_disp = [-1 for i in 1:40*6]
    disp = reshape(raw_disp, 40, 6)'

    draw = () -> begin
        column = CRT % 40
        line = CRT ÷ 40

        if X - 1 <= column <= X + 1
            disp[line+1, column+1] = 1
        else
            disp[line+1, column+1] = 0
        end
    end

    print_grid = () -> begin
        grid = map(s -> s == 1 ? "🟩" : s == 0 ? "🟫" : " ", disp)
        for g in eachrow(grid)
            println(join(g, ""))
        end
    end

    for instr in instructions
        draw()
        CRT += 1

        if startswith(instr, "add")
            draw()
            CRT += 1
            X += parse(Int64, split(instr, " ")[2])
        end
    end

    print_grid()
    return 0
end

function test()
    example = """addx 15
addx -11
addx 6
addx -3
addx 5
addx -1
addx -8
addx 13
addx 4
noop
addx -1
addx 5
addx -1
addx 5
addx -1
addx 5
addx -1
addx 5
addx -1
addx -35
addx 1
addx 24
addx -19
addx 1
addx 16
addx -11
noop
noop
addx 21
addx -15
noop
noop
addx -3
addx 9
addx 1
addx -3
addx 8
addx 1
addx 5
noop
noop
noop
noop
noop
addx -36
noop
addx 1
addx 7
noop
noop
noop
addx 2
addx 6
noop
noop
noop
noop
noop
addx 1
noop
noop
addx 7
addx 1
noop
addx -13
addx 13
addx 7
noop
addx 1
addx -33
noop
noop
noop
addx 2
noop
noop
noop
addx 8
noop
addx -1
addx 2
addx 1
noop
addx 17
addx -9
addx 1
addx 1
addx -3
addx 11
noop
noop
addx 1
noop
addx 1
noop
noop
addx -13
addx -19
addx 1
addx 3
addx 26
addx -30
addx 12
addx -1
addx 3
addx 1
noop
noop
noop
addx -9
addx 18
addx 1
addx 2
noop
noop
addx 9
noop
noop
noop
addx -1
addx 2
addx -37
addx 1
addx 3
noop
addx 15
addx -21
addx 22
addx -6
addx 1
noop
addx 2
addx 1
noop
addx -10
noop
noop
addx 20
addx 1
addx 2
addx 2
addx -6
addx -11
noop
noop
noop"""

    @test part_one(example) == 13140
    @test part_two(example) == 0
end
