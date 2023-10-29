using Test

function input_to_matrix(input)
    b = split.(strip.(split(input, "\n")), "")
    intb = map(c -> parse.(Int, c), b)

    return reduce(hcat, intb)
end

function increase_neighbours!(energy, x, y)
    (mx, my) = size(energy)
    for (i, j) in [(a, b) for a = (x-1):(x+1) for b in (y-1):(y+1) if a != x || b != y]
        if 1 <= i <= mx && 1 <= j <= my
            energy[i, j] += 1
        end
    end
end

function step!(energy)
    (mx, my) = size(energy)

    energy .+= 1
    flashed_idx = []
    flashed = count(>(9), energy) > 0

    while flashed
        flashed = false
        for x = 1:mx
            for y = 1:my
                if energy[x, y] > 9 && !((x, y) in flashed_idx)
                    increase_neighbours!(energy, x, y)
                    push!(flashed_idx, (x, y))
                    flashed = true
                end
            end
        end
    end

    map!(e -> e > 9 ? 0 : e, energy, energy)
    return length(flashed_idx)
end

function part_one(input)
    energy = input_to_matrix(input)

    flashes = 0
    for _ = 1:100
        flashes += step!(energy)
    end
    return flashes
end

function part_two(input)
    energy = input_to_matrix(input)
    (l, c) = size(energy)
    i = 0
    while true
        flashes = step!(energy)
        i += 1

        if flashes == l * c
            break
        end
    end
    return i
end

function test()
    example = """5483143223
2745854711
5264556173
6141336146
6357385478
4167524645
2176841721
6882881134
4846848554
5283751526"""

    @test part_one(example) == 1656
    @test part_two(example) == 195
end
