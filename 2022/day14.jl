using Test
using Images
using FileIO
using Printf

const AIR = 0
const ROCK = 1
const SAND = 2
const PRODUCER = 3

function get_boundaries(input)
    min_x = 500
    max_x = 500
    max_y = 0

    for pair in split.(split(input, "\n"), " -> ") |> Iterators.flatten |> collect
        (x, y) = parse.(Int, split(pair, ","))
        min_x = min(min_x, x)
        max_x = max(max_x, x)
        max_y = max(max_y, y)
    end

    return (min_x, max_x, 0, max_y)
end

function parse_line(line, min_x)
    return map((p) -> (parse(Int, p[1]) - min_x + 1, parse(Int, p[2]) + 1), split.(split(line, " -> "), ","))
end

function fill_grid!(grid, input, min_x)
    for line in parse_line.(split(input, "\n"), min_x)
        for ((from_x, from_y), (to_x, to_y)) in zip(line, line[2:end])
            grid[
                from_y < to_y ? (from_y:to_y) : (to_y:from_y),
                from_x < to_x ? (from_x:to_x) : (to_x:from_x)
            ] .= ROCK
        end
    end
end

function process!(grid, producer)
    counter = 0
    j = 0
    i = 0

    while true
        (x, y) = producer
        try
            while true
                if j % 100 == 0
                    to_img(grid, i)
                    i += 1
                end
                j += 1

                if grid[x+1, y] == AIR
                    grid[x, y] = AIR
                    x += 1
                elseif grid[x+1, y-1] == AIR
                    grid[x, y] = AIR
                    y -= 1
                    x += 1
                elseif grid[x+1, y+1] == AIR
                    grid[x, y] = AIR
                    x += 1
                    y += 1
                elseif (x, y) == producer
                    counter += 1
                    return counter
                else
                    counter += 1
                    break
                end

                # Changing here for the visualization
                grid[producer...] = PRODUCER
                grid[x, y] = SAND
                # println(counter)
                # display(grid)
                # println()
                # readline()
            end


        catch err
            if isa(err, BoundsError)
                grid[x, y] = AIR
                return counter
            end
        end

    end
end

function append_columns(grid, n=1)
    c = zeros(Int, size(grid)[1], n)
    c[end, 1:end] .= ROCK
    return [grid c]
end

function prepend_columns(grid, n=1)
    c = zeros(Int, size(grid)[1], n)
    c[end, 1:end] .= ROCK
    return [c grid]
end

function display(grid)
    disp = map((g) -> g == ROCK ? "🪨 " : g == SAND ? "🟡" : g == PRODUCER ? "➕" : "🔲", grid)
    for g in eachrow(disp)
        println(join(g, ""))
    end
end

function to_img(grid, i)
    img = map(n ->
            n == ROCK ? RGB(153 / 256, 102 / 256, 51 / 256) :
            n == SAND ? RGB(1.0, 1.0, 0.0) :
            n == PRODUCER ? RGB(102 / 256, 0.0, 204 / 256) :
            RGB(0.0, 0.0, 0.0), grid)
    FileIO.save("vis/test$(@sprintf("%06d", i)).png", img)
end

function part_one(input)
    (min_x, max_x, min_y, max_y) = get_boundaries(input)
    grid = zeros(Int, max_y - min_y + 1, max_x - min_x + 1)
    fill_grid!(grid, input, min_x)

    producer = (1, 500 - min_x + 1)
    grid[producer...] = PRODUCER

    counter = process!(grid, producer)

    return counter
end

function part_two(input)
    (min_x, max_x, min_y, max_y) = get_boundaries(input)
    grid = zeros(Int, max_y - min_y + 3, max_x - min_x + 1)
    fill_grid!(grid, input, min_x)
    grid[end, 1:end] .= ROCK
    py = 500 - min_x + 1

    (h, w) = size(grid)

    to_left = h - py
    to_right = h - (w - py + 1)

    grid = append_columns(grid, to_right)
    grid = prepend_columns(grid, to_left)
    py += to_left

    producer = (1, py)
    grid[producer...] = PRODUCER

    counter = process!(grid, producer)

    return counter
end

function test()
    example = """498,4 -> 498,6 -> 496,6
503,4 -> 502,4 -> 502,9 -> 494,9"""

    @test part_one(example) == 24
    @test part_two(example) == 93
end
