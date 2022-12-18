using Test
using CircularArrays

const shapes = CircularArray(["-", "+", "L", "I", "O"])

# width, height
const shape_info = Dict(
    "-" => (1, 4, [0 0 0 0; 0 0 0 0; 0 0 0 0; 1 1 1 1]),
    "+" => (3, 3, [0 0 0 0; 0 1 0 0; 1 1 1 0; 0 1 0 0]),
    "L" => (3, 3, [0 0 0 0; 0 0 1 0; 0 0 1 0; 1 1 1 0]),
    "I" => (4, 1, [1 0 0 0; 1 0 0 0; 1 0 0 0; 1 0 0 0]),
    "O" => (2, 2, [0 0 0 0; 0 0 0 0; 1 1 0 0; 1 1 0 0]),
)

const print_field = (field) -> begin
    grid = map(s -> s == 1 ? "🟩" : s == 0 ? "🟫" : "✴️ ", field)
    for g in eachrow(grid)
        println(join(g, ""))
    end
    println()
end

function part_one(input, amt=2022, from_pat=nothing)
    movements = CircularArray(split(input, ""))
    height = 0
    amount = 0
    found_at = 0

    field = [ones(Int8, 7, 3) zeros(Int8, 7, 7) ones(Int8, 7, 4); ones(Int8, 1, 14)]

    shape_idx = 1
    movement_idx = 1
    while true
        shape = shapes[shape_idx]
        (h, w, data) = shape_info[shape]
        pos = [4 6]

        # println("spawn $shape")
        # c = copy(field)
        # c[pos[1]-3:pos[1], pos[2]:pos[2]+3] += data * 2
        # print_field(c)

        while true
            move = movements[movement_idx]
            movement_idx += 1

            if move == ">"
                pos += [0 1]
                if any(field[pos[1]-3:pos[1], pos[2]:pos[2]+3] + data .== 2)
                    pos += [0 -1]
                end
            elseif move == "<"
                pos += [0 -1]
                if any(field[pos[1]-3:pos[1], pos[2]:pos[2]+3] + data .== 2)
                    pos += [0 1]
                end
            end

            # println("$move $pos")
            # c = copy(field)
            # c[pos[1]-3:pos[1], pos[2]:pos[2]+3] += data * 2
            # print_field(c)

            pos += [1 0]

            # println("V $pos")
            if any(field[pos[1]-3:pos[1], pos[2]:pos[2]+3] + data .== 2)
                pos += [-1 0]
                field[pos[1]-3:pos[1], pos[2]:pos[2]+3] += data
                # print_field(field)
                if from_pat === nothing || found_at > 0
                    amount += 1
                end
                height_to_add = 7 - (pos[1] - h)
                if height_to_add > 0
                    field = [ones(Int8, height_to_add, 3) zeros(Int8, height_to_add, 7) ones(Int8, height_to_add, 4); field]
                end
                break
            end

            # c = copy(field)
            # c[pos[1]-3:pos[1], pos[2]:pos[2]+3] += data * 2
            # print_field(c)

            # print_field(field)

        end
        shape_idx += 1

        if from_pat !== nothing && found_at == 0
            #look for pattern
            pat = (findfirst.(x -> x == 1, eachcol(field[1:end, 4:10]))..., shape, movement_idx % length(input))
            if pat == from_pat
                found_at = size(field)[1] - 8
            end
        end

        # print_field(field)
        if amount == amt
            break
        end
    end

    return size(field)[1] - 8 - found_at
end

# const print_flags = [i * 10_000_000 for i in 0:1000]


function part_two(input, amt=1_000_000_000_000)
    flag = 0
    first_pat = nothing
    movements = CircularArray(split(input, ""))
    amount = 0

    field = [ones(Int8, 7, 3) zeros(Int8, 7, 7) ones(Int8, 7, 4); ones(Int8, 1, 14)]

    shape_idx = 1
    movement_idx = 1

    patterns = Dict{Tuple{Int,Int,Int,Int,Int,Int,Int,String,Int},Int}()

    heights = [(0, 0), (0, 0)]

    while true
        shape = shapes[shape_idx]
        (h, w, data) = shape_info[shape]
        pos = [4 6]

        while true
            move = movements[movement_idx]
            movement_idx += 1

            if move == ">"
                pos += [0 1]
                if any(field[pos[1]-3:pos[1], pos[2]:pos[2]+3] + data .== 2)
                    pos += [0 -1]
                end
            elseif move == "<"
                pos += [0 -1]
                if any(field[pos[1]-3:pos[1], pos[2]:pos[2]+3] + data .== 2)
                    pos += [0 1]
                end
            end

            pos += [1 0]

            if any(field[pos[1]-3:pos[1], pos[2]:pos[2]+3] + data .== 2)
                pos += [-1 0]
                field[pos[1]-3:pos[1], pos[2]:pos[2]+3] += data
                amount += 1
                height_to_add = 7 - (pos[1] - h)
                if height_to_add > 0
                    field = [ones(Int8, height_to_add, 3) zeros(Int8, height_to_add, 7) ones(Int8, height_to_add, 4); field]
                end

                break
            end
        end

        # find first repeating pattern
        pat = (findfirst.(x -> x == 1, eachcol(field[1:end, 4:10]))..., shape, movement_idx % length(input))
        if pat in keys(patterns) && (first_pat === nothing || pat == first_pat)
            first_pat = pat
            patterns[pat] += 1
            println("found pattern at $(size(field)[1] - 8) -> $pat -> $(patterns[pat]) -> $amount")

            # save next two times it repeats
            if heights[1] == (0, 0)
                heights[1] = (size(field)[1] - 8, amount)
            else
                heights[2] = (size(field)[1] - 8, amount)
                break
            end
        else
            patterns[pat] = 1
        end

        shape_idx += 1
    end

    total = 1_000_000_000_000
    total -= heights[1][2]

    rdiff = heights[2][2] - heights[1][2]
    hdiff = heights[2][1] - heights[1][1]

    d, r = divrem(total, rdiff)

    return heights[1][1] + part_one(input, r, first_pat) + d * hdiff
    # return height + size(field)[1] - 8
end

function test()
    example = """>>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>"""

    @test part_one(example) == 3068
    @test part_two(example) == 1514285714288
end
