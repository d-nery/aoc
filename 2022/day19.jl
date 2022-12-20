using Test
using DataStructures
using AutoHashEquals

@auto_hash_equals mutable struct State
    mats::NTuple{4,UInt16}
    bots::NTuple{4,UInt16}
    time::UInt8
end

function parse_bp(line)
    (id, ore_bot_ore, clay_bot_ore, obs_bot_ore, obs_bot_clay, geode_bot_ore, geode_bot_obsidian) = [parse(Int, m.match) for m in eachmatch(r"\d+", line)]
    return (id, ore_bot_ore, clay_bot_ore, obs_bot_ore, obs_bot_clay, geode_bot_ore, geode_bot_obsidian)
end

function solve(blueprints, m)
    total = []

    for line in blueprints
        bp = parse_bp(line)

        # (ore, clay, obs, geode), (ore_bots, clay_bots, obsidian_bots, geode_obs), time
        Q = Vector{State}()
        push!(Q, State((0, 0, 0, 0), (1, 0, 0, 0), m))
        geodes = 0
        visited = Set{State}()

        max_ore_cost = max(bp[2], bp[3], bp[4], bp[6])
        max_clay_cost = bp[5]
        max_obs_cost = bp[7]

        # bfs?
        while !isempty(Q)
            s = popfirst!(Q)
            geodes = max(geodes, s.mats[4])
            if s.time == 0 || s in visited
                continue
            end

            push!(visited, s)

            push!(Q, State(s.mats .+ s.bots, s.bots, s.time - 1))

            if s.mats[1] >= bp[2] && s.bots[1] < max_ore_cost
                push!(Q, State(s.mats .+ s.bots .- (bp[2], 0, 0, 0), s.bots .+ (1, 0, 0, 0), s.time - 1))
            end

            if s.mats[1] >= bp[3] && s.bots[2] < max_clay_cost
                push!(Q, State(s.mats .+ s.bots .- (bp[3], 0, 0, 0), s.bots .+ (0, 1, 0, 0), s.time - 1))
            end

            if s.mats[1] >= bp[4] && s.mats[2] >= bp[5] && s.bots[3] < max_obs_cost
                push!(Q, State(s.mats .+ s.bots .- (bp[4], bp[5], 0, 0), s.bots .+ (0, 0, 1, 0), s.time - 1))
            end

            if s.mats[1] >= bp[6] && s.mats[3] >= bp[7]
                push!(Q, State(s.mats .+ s.bots .- (bp[6], 0, bp[7], 0), s.bots .+ (0, 0, 0, 1), s.time - 1))
            end

            # Remove useless states
        end

        push!(total, (bp[1], geodes))
        println("Blueprint $(bp[1]) finished with $geodes, total = $total")
    end
    return total
end

function part_one(input)
    totals = solve(split(input, "\n"), 24)
    return reduce((r, e) -> r += e[1] * e[2], totals; init=0)
end

# not working
function part_two(input, n=3)
    totals = solve(split(input, "\n")[1:n], 32)
    return reduce((r, e) -> r *= e[2], totals; init=1)
end

function test()
    example = """Blueprint 1: Each ore robot costs 4 ore. Each clay robot costs 2 ore. Each obsidian robot costs 3 ore and 14 clay. Each geode robot costs 2 ore and 7 obsidian.
Blueprint 2: Each ore robot costs 2 ore. Each clay robot costs 3 ore. Each obsidian robot costs 3 ore and 8 clay. Each geode robot costs 3 ore and 12 obsidian."""

    @test part_one(example) == 33
    # @test part_two(example, 2) == 56 * 62
end
