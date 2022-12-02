using Test

@enum Play Rock Paper Scissors
@enum Condition::Int64 VICTORY = 6 TIE = 3 LOSS = 0

input_to_rps = Dict(
    "A" => Rock,
    "B" => Paper,
    "C" => Scissors,
    "X" => Rock,
    "Y" => Paper,
    "Z" => Scissors,
)

input_to_condition = Dict(
    "X" => LOSS,
    "Y" => TIE,
    "Z" => VICTORY,
)

function get_point(opponent, you)
    if you == Rock
        return 1 + Int64(opponent == Rock ? TIE : opponent == Paper ? LOSS : VICTORY)
    elseif you == Paper
        return 2 + Int64(opponent == Paper ? TIE : opponent == Scissors ? LOSS : VICTORY)
    else # scissors
        return 3 + Int64(opponent == Scissors ? TIE : opponent == Rock ? LOSS : VICTORY)
    end
end

function get_play(opponent, condition)
    if condition == LOSS
        return opponent == Rock ? Scissors : opponent == Paper ? Rock : Paper
    elseif condition == TIE
        return opponent
    else # win
        return opponent == Rock ? Paper : opponent == Paper ? Scissors : Rock
    end
end

function part_one(input)
    rounds = split(input, "\n")
    return reduce((r, e) -> begin
            m = split(e, " ")
            return r + get_point(input_to_rps[m[1]], input_to_rps[m[2]])
        end, rounds; init=0)
end

function part_two(input)
    rounds = split(input, "\n")
    return reduce((r, e) -> begin
            m = split(e, " ")
            return r + get_point(
                input_to_rps[m[1]],
                get_play(input_to_rps[m[1]], input_to_condition[m[2]]))
        end, rounds; init=0)
end

function test()
    example = """A Y
B X
C Z"""

    @test part_one(example) == 15
    @test part_two(example) == 12
end
