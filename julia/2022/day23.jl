using Test
using DataStructures
using CircularArrays

mutable struct DictGrid
    d::DefaultDict{Tuple{Int,Int},Int}
    minx::Int
    maxx::Int
    miny::Int
    maxy::Int
end

const EMPTY = 0

const ELF = 5
const ELF_N = 6
const ELF_S = 7
const ELF_W = 8
const ELF_E = 9

const dump_dict = Dict(
    EMPTY => "🟫",
    1 => "🟣",
    2 => "🔴",
    3 => "🔴",
    4 => "🔴",
    ELF => "🟩",
    ELF_N => "⏫",
    ELF_S => "⏬",
    ELF_W => "⏪",
    ELF_E => "⏩",
)

function to_string(grid)
    s = ""
    for y in grid.miny:grid.maxy
        for x in grid.minx:grid.maxx
            s *= grid.d[(x, y)] == EMPTY ? "." : "#"
        end
    end
    return s
end

function dump(grid)
    for y in grid.miny:grid.maxy
        for x in grid.minx:grid.maxx
            print(dump_dict[grid.d[(x, y)]])
        end
        println()
    end
    println()
end

function parse_input(input)
    d = DefaultDict{Tuple{Int,Int},Int}(0)
    m = split(input, "\n")
    (my, mx) = (size(m)[1], length(m[1]))

    for y in 1:my
        for x in 1:mx
            d[(x, y)] = m[y][x] == '.' ? EMPTY : ELF
        end
    end

    return DictGrid(d, 1, mx, 1, my)
end

function step!(g, direction)
    neighbours = (x, y) -> [g.d[pos] for pos in [
        (x - 1, y - 1), (x, y - 1), (x + 1, y - 1),
        (x - 1, y), (x + 1, y),
        (x - 1, y + 1), (x, y + 1), (x + 1, y + 1),
    ]]

    north = (x, y) -> g.d[(x - 1, y - 1)] < ELF && g.d[(x, y - 1)] < ELF && g.d[(x + 1, y - 1)] < ELF
    south = (x, y) -> g.d[(x - 1, y + 1)] < ELF && g.d[(x, y + 1)] < ELF && g.d[(x + 1, y + 1)] < ELF
    west = (x, y) -> g.d[(x - 1, y - 1)] < ELF && g.d[(x - 1, y)] < ELF && g.d[(x - 1, y + 1)] < ELF
    east = (x, y) -> g.d[(x + 1, y - 1)] < ELF && g.d[(x + 1, y)] < ELF && g.d[(x + 1, y + 1)] < ELF

    prepare_north = (x, y) -> begin
        g.d[(x, y - 1)] += 1
        g.d[(x, y)] = ELF_N
        g.miny = min(g.miny, y - 1)
    end

    prepare_south = (x, y) -> begin
        g.d[(x, y + 1)] += 1
        g.d[(x, y)] = ELF_S
        g.maxy = max(g.maxy, y + 1)
    end

    prepare_west = (x, y) -> begin
        g.d[(x - 1, y)] += 1
        g.d[(x, y)] = ELF_W
        g.minx = min(g.minx, x - 1)
    end

    prepare_east = (x, y) -> begin
        g.d[(x + 1, y)] += 1
        g.d[(x, y)] = ELF_E
        g.maxx = max(g.maxx, x + 1)
    end

    for (x, y) in keys(g.d)
        if (g.d[(x, y)] < ELF)
            continue
        end

        if all(neighbours(x, y) .< ELF)
            continue
        end

        if direction == "N"
            if north(x, y)
                prepare_north(x, y)
            elseif south(x, y)
                prepare_south(x, y)
            elseif west(x, y)
                prepare_west(x, y)
            elseif east(x, y)
                prepare_east(x, y)
            end
        elseif direction == "S"
            if south(x, y)
                prepare_south(x, y)
            elseif west(x, y)
                prepare_west(x, y)
            elseif east(x, y)
                prepare_east(x, y)
            elseif north(x, y)
                prepare_north(x, y)
            end
        elseif direction == "W"
            if west(x, y)
                prepare_west(x, y)
            elseif east(x, y)
                prepare_east(x, y)
            elseif north(x, y)
                prepare_north(x, y)
            elseif south(x, y)
                prepare_south(x, y)
            end
        elseif direction == "E"
            if east(x, y)
                prepare_east(x, y)
            elseif north(x, y)
                prepare_north(x, y)
            elseif south(x, y)
                prepare_south(x, y)
            elseif west(x, y)
                prepare_west(x, y)
            end
        end

    end

    for (x, y) in keys(g.d)
        if g.d[(x, y)] <= ELF
            continue
        end

        if g.d[(x, y)] == ELF_N
            if g.d[(x, y - 1)] == 1
                g.d[(x, y)] = EMPTY
                g.d[(x, y - 1)] = ELF
            else
                g.d[(x, y)] = ELF
                g.d[(x, y - 1)] = EMPTY
            end
        elseif g.d[(x, y)] == ELF_S
            if g.d[(x, y + 1)] == 1
                g.d[(x, y)] = EMPTY
                g.d[(x, y + 1)] = ELF
            else
                g.d[(x, y)] = ELF
                g.d[(x, y + 1)] = EMPTY
            end
        elseif g.d[(x, y)] == ELF_W
            if g.d[(x - 1, y)] == 1
                g.d[(x, y)] = EMPTY
                g.d[(x - 1, y)] = ELF
            else
                g.d[(x, y)] = ELF
                g.d[(x - 1, y)] = EMPTY
            end
        elseif g.d[(x, y)] == ELF_E
            if g.d[(x + 1, y)] == 1
                g.d[(x, y)] = EMPTY
                g.d[(x + 1, y)] = ELF
            else
                g.d[(x, y)] = ELF
                g.d[(x + 1, y)] = EMPTY
            end
        end
    end

    return g
end

function part_one(input)
    g = parse_input(input)
    dump(g)

    directions = CircularArray(["N", "S", "W", "E"])
    dir = 1

    for round in 1:10
        println("Round $round")
        step!(g, directions[dir])
        dir += 1
    end

    empty = 0
    for x in g.minx:g.maxx
        for y in g.miny:g.maxy
            if g.d[(x, y)] != EMPTY
                continue
            end
            empty += 1
        end
    end

    return empty
end

function part_two(input)
    g = parse_input(input)
    # dump(g)

    directions = CircularArray(["N", "S", "W", "E"])
    dir = 1

    round = 1
    while true
        pre_str = to_string(g)
        step!(g, directions[dir])
        dir += 1
        if pre_str == to_string(g)
            break
        end
        round += 1
    end

    return round
end

function test()
    example = """....#..
..###.#
#...#.#
.#...##
#.###..
##.#.##
.#..#.."""

    @test part_one(example) == 110
    @test part_two(example) == 20
end
