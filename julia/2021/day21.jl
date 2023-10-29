using Test

function part_one(input)
    runs = 0
    dice = 0

    i1, i2 = split(input, "\n")
    i1 = parse(Int, i1[end])
    i2 = parse(Int, i2[end])

    p1 = [i1, 0]
    p2 = [i2, 0]

    players = [p1, p2]

    while true
        for p in players
            d = 0
            for _ = 1:3
                dice = (dice % 100) + 1
                d += dice
            end

            p[1] = (p[1] + d) % 10 == 0 ? 10 : (p[1] + d) % 10
            p[2] += p[1]
            runs += 3

            if p[2] >= 1000
                return runs * min(p1[2], p2[2])
            end
        end
    end
end

function run(p1, p2, roll, score_dict)
    # score dict is game status -> who wins (p1, p2)
    if haskey(score_dict, (p1, p2, roll))
        return score_dict[(p1, p2, roll)]
    end

    if p1[2] >= 21
        score_dict[(p1, p2, roll)] = (1, 0)
        return (1, 0)
    elseif p2[2] >= 21
        score_dict[(p1, p2, roll)] = (0, 1)
        return (0, 1)
    end

    wins = (0, 0)
    for d = 1:3
        # first 3 rolls for first Player
        if roll < 3
            next_pos = (p1[1] + d) % 10 == 0 ? 10 : (p1[1] + d) % 10
            next_points = p1[2] + (roll == 2 ? next_pos : 0)
            wins = wins .+ run([next_pos, next_points], p2, (roll + 1) % 6, score_dict)
        else
            next_pos = (p2[1] + d) % 10 == 0 ? 10 : (p2[1] + d) % 10
            next_points = p2[2] + (roll == 5 ? next_pos : 0)
            wins = wins .+ run(p1, [next_pos, next_points], (roll + 1) % 6, score_dict)
        end
    end

    score_dict[(p1, p2, roll)] = wins
    return wins
end

function part_two(input)
    i1, i2 = split(input, "\n")
    i1 = parse(Int, i1[end])
    i2 = parse(Int, i2[end])

    p1 = [i1, 0]
    p2 = [i2, 0]

    scores = Dict()
    return run(p1, p2, 0, scores)
end

function test()
    example = """Player 1 starting position: 4
Player 2 starting position: 8"""

    @test part_one(example) == 739785
    @test part_two(example) == (444356092776315, 341960390180808)
end
