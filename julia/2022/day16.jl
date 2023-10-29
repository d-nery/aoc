using Test
using Memoize
using Combinatorics

mutable struct Valve
    paths::Array{String}
    rate::Int
end


function parse_tunnels(input)
    valves = Dict{String,Valve}()

    for line in split(input, "\n")
        info = split(line, " ")
        name = info[2]
        rate = parse(Int, split(info[5][1:end-1], "=")[2])
        paths = split(join(info[10:end], " "), ", ")

        valves[name] = Valve(paths, rate)
    end

    return valves
end

function part_one(input)
    valves = parse_tunnels(input)

    @memoize Dict function dfs(current, opened, minutes)
        pressure = 0

        if minutes <= 0
            return pressure
        end

        # Walk everywhere
        for valve in valves[current].paths
            pressure = max(pressure, dfs(valve, opened, minutes - 1))
        end

        # Open if closed and rate > 0
        if current ∉ opened && valves[current].rate > 0
            p = valves[current].rate * (minutes - 1)
            pressure = max(pressure, p + dfs(current, opened ∪ [current], minutes - 1))
        end

        # println("$("  " ^ (30-minutes))$current |$(join(sort!(opened), " "))| $minutes | $pressure")
        return pressure
    end

    return dfs("AA", Array{String,1}(), 30)
end

# Veeery slow xD
function part_two(input)
    valves = parse_tunnels(input)

    @memoize Dict function dfs(current, opened, minutes, n)
        pressure = 0
        if n == 0
            return pressure
        end

        # Run again for elephant with valves already opened
        if minutes <= 0
            return dfs("AA", opened, 26, n - 1)
        end

        # Walk everywhere
        # rl = ReentrantLock()
        # Base.Threads.@threads
        for valve in valves[current].paths
            v = dfs(valve, opened, minutes - 1, n)
            # lock(rl) do
                pressure = max(v, pressure)
            # end
        end

        # Open if closed and rate > 0
        if current ∉ opened && valves[current].rate > 0
            p = valves[current].rate * (minutes - 1)
            pressure = max(pressure, p + dfs(current, opened ∪ [current], minutes - 1, n))
        end

        return pressure
    end

    return dfs("AA", Array{String,1}(), 26, 2)
end

function test()
    example = """Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
Valve BB has flow rate=13; tunnels lead to valves CC, AA
Valve CC has flow rate=2; tunnels lead to valves DD, BB
Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE
Valve EE has flow rate=3; tunnels lead to valves FF, DD
Valve FF has flow rate=0; tunnels lead to valves EE, GG
Valve GG has flow rate=0; tunnels lead to valves FF, HH
Valve HH has flow rate=22; tunnel leads to valve GG
Valve II has flow rate=0; tunnels lead to valves AA, JJ
Valve JJ has flow rate=21; tunnel leads to valve II"""

    @test part_one(example) == 1651
    @test part_two(example) == 1707
end
