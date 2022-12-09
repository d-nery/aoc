using Test

walk_dir = Dict(
    "R" => [1, 0],
    "L" => [-1, 0],
    "U" => [0, 1],
    "D" => [0, -1],
)

follow_dir = (x, y) -> round.((x - y) ./ 2, RoundNearestTiesAway)

function follow(head_pos, tail_pos)
    diff = abs.(head_pos - tail_pos)
    if all(diff .<= 1)
        return tail_pos
    end

    return tail_pos + follow_dir(head_pos, tail_pos)
end

function part_one(input, knots=2)
    instructions = split.(split(input, "\n"), " ")

    visited = Set{Vector{Int64}}()

    rope_pos = [[0, 0] for _ in 1:knots]

    push!(visited, rope_pos[end])
    for (dir, qty) in instructions
        for _ in 1:parse.(Int64, qty)
            rope_pos[1] .+= walk_dir[dir]
            for i in 2:knots
                rope_pos[i] = follow(rope_pos[i-1], rope_pos[i])
            end
            push!(visited, rope_pos[end])
        end
    end

    return length(visited)
end

function part_two(input)
    return part_one(input, 10)
end

function test()
    example = """R 4
U 4
L 3
D 1
R 4
D 1
L 5
R 2"""

    example2 = """R 5
U 8
L 8
D 3
R 17
D 10
L 25
U 20"""

    @test part_one(example) == 13
    @test part_two(example) == 1
    @test part_two(example2) == 36
end
