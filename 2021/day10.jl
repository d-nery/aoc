using Test
using DataStructures
using Statistics

point_map = Dict(
    ')' => 3,
    ']' => 57,
    '}' => 1197,
    '>' => 25137,
)

point_map_completion = Dict(
    '(' => 1,
    '[' => 2,
    '{' => 3,
    '<' => 4,
)

match_map = Dict(
    '(' => ')',
    '[' => ']',
    '{' => '}',
    '<' => '>',
)

function is_valid(line)
    process_stack = Stack{Char}()

    for c in line
        if haskey(match_map, c)
            push!(process_stack, c)
        else
            match = pop!(process_stack)
            if match_map[match] != c
                return (false, point_map[c])
            end
        end
    end

    return (true, process_stack)
end

function part_one(input)
    lines = split(input, "\n")

    score = reduce(lines; init = 0) do s, line
        (valid, v) = is_valid(line)
        if !valid
            s += v
        end

        return s
    end

    return score
end

function part_two(input)
    lines = split(input, "\n")
    scores = reduce(lines; init = []) do score, line
        (valid, stack) = is_valid(line)
        if !valid
            return score
        end

        s = 0
        while !isempty(stack)
            c = pop!(stack)
            s *= 5
            s += point_map_completion[c]
        end
        push!(score, s)
        return score
    end

    return Int(median(scores))
end

function test()
    example = """[({(<(())[]>[[{[]{<()<>>
[(()[<>])]({[<{<<[]>>(
{([(<{}[<>[]}>{[]{[(<()>
(((({<>}<{<{<>}{[]{[]{}
[[<[([]))<([[{}[[()]]]
[{[{({}]{}}([{[{{{}}([]
{<[[]]>}<{[{[{[]{()[[[]
[<(<(<(<{}))><([]([]()
<{([([[(<>()){}]>(<<{{
<{([{{}}[<[[[<>{}]]]>[]]"""

    @test part_one(example) == 26397
    @test part_two(example) == 288957
end
