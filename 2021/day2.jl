using Test

function position_calculator(pos, instr)
    X = parse(Int64, instr[2])

    pos[1] += instr[1] == "forward" ? X : 0
    pos[2] += instr[1] == "down" ? X : instr[1] == "up" ? -X : 0

    return pos
end

function position_calculator_with_aim(pos, instr)
    X = parse(Int64, instr[2])

    pos[1] += instr[1] == "forward" ? X : 0
    pos[2] += instr[1] == "forward" ? pos[3] * X : 0
    pos[3] += instr[1] == "down" ? X : instr[1] == "up" ? -X : 0

    return pos
end

function part_one(input, calculator = position_calculator)
    instructions = split.(split(input, "\n"), " ")

    position = reduce(calculator, instructions; init = [0, 0, 0])
    return prod(position[1:2])
end

function part_two(input)
    return part_one(input, position_calculator_with_aim)
end

function test()
    example = """forward 5
down 5
forward 8
up 3
down 8
forward 2"""

    @test part_one(example) == 150
    @test part_two(example) == 900
end
