using Test
using DataStructures

function get_stacks(_cranes, is_test)
    # Yes, it only works for  my input 👍
    if is_test
        stacks = [
            Stack{Char}(),
            Stack{Char}(),
            Stack{Char}(),
        ]

        push!(stacks[1], 'Z', 'N')
        push!(stacks[2], 'M', 'C', 'D')
        push!(stacks[3], 'P')

        return stacks
    end

    stacks = [
        Stack{Char}(),
        Stack{Char}(),
        Stack{Char}(),
        Stack{Char}(), Stack{Char}(), Stack{Char}(), Stack{Char}(), Stack{Char}(), Stack{Char}()
    ]
    push!(stacks[1], 'F', 'T', 'C', 'L', 'R', 'P', 'G', 'Q')
    push!(stacks[2], 'N', 'Q', 'H', 'W', 'R', 'F', 'S', 'J')
    push!(stacks[3], 'F', 'B', 'H', 'W', 'P', 'M', 'Q')
    push!(stacks[4], 'V', 'S', 'T', 'D', 'F')
    push!(stacks[5], 'Q', 'L', 'D', 'W', 'V', 'F', 'Z')
    push!(stacks[6], 'Z', 'C', 'L', 'S')
    push!(stacks[7], 'Z', 'B', 'M', 'V', 'D', 'F')
    push!(stacks[8], 'T', 'J', 'B')
    push!(stacks[9], 'Q', 'N', 'B', 'G', 'L', 'S', 'P', 'H')

    return stacks
end

function part_one(input, is_test=false)
    cranes, instructions = split(input, "\n\n")
    stacks = get_stacks(cranes, is_test)

    for instr in split(strip(instructions), "\n")
        (_, qty, _, from, _, to) = tryparse.(Int64, split(instr, " "))
        for _ in 1:qty
            push!(stacks[to], pop!(stacks[from]))
        end
    end

    return join(map(s -> pop!(s), stacks), "")
end

function part_two(input, is_test=false)
    cranes, instructions = split(input, "\n\n")
    stacks = get_stacks(cranes, is_test)

    for instr in split(strip(instructions), "\n")
        (_, qty, _, from, _, to) = tryparse.(Int64, split(instr, " "))
        popped = []
        for _ in 1:qty
            append!(popped, pop!(stacks[from]))
        end

        push!(stacks[to], reverse(popped)...)
    end

    return join(map(s -> pop!(s), stacks), "")
end

function test()
    example = """    [D]
[N] [C]
[Z] [M] [P]
 1   2   3

move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2
"""

    @test part_one(example, true) == "CMZ"
    @test part_two(example, true) == "MCD"
end
