using Test

const EMPTY = 0b00000
const WALL = 0b10000
const BLIZZ_E = 0b00001
const BLIZZ_S = 0b00010
const BLIZZ_W = 0b00100
const BLIZZ_N = 0b01000

function input_to_matrix(input)
    b = split.(strip.(split(input, "\n")), "")
    intb = map.(c ->
            c == "#" ? WALL :
            c == ">" ? BLIZZ_E :
            c == "v" ? BLIZZ_S :
            c == "<" ? BLIZZ_W :
            c == "^" ? BLIZZ_N :
            EMPTY, b)

    return permutedims(reduce(hcat, intb))
end

function step!(grid)
    (sy, sx) = size(grid) .- 2
    inside = zeros(Int, sy, sx)

    for y in 2:sy+1
        for x in 2:sx+1
            cell = grid[y, x]
            if cell == EMPTY
                continue
            end


        end
    end

    grid[2:end-1, 2:end-1] = inside
end

function dump(grid)
    disp = map((g) -> g == WALL ? "🟫" : g == BLIZZ_E ? "⏩" : g == BLIZZ_N ? "⏫" : g == BLIZZ_S ? "⏬" : g == BLIZZ_W ? "⏪" : "🔲", grid)
    for g in eachrow(disp)
        println(join(g, ""))
    end
end


function part_one(input)
    grid = input_to_matrix(input)
    dump(grid)
    return 0
end

function part_two(input)
    return 0
end

function test()
    example = """#.######
#>>.<^<#
#.<..<<#
#>v.><>#
#<^v^^>#
######.#"""

    @test part_one(example) == 18
    @test part_two(example) == 0
end
