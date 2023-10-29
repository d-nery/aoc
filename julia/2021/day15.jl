using Test
using DataStructures

function input_to_matrix(input)
    b = split.(strip.(split(input, "\n")), "")
    intb = map(c -> parse.(Int, c), b)

    return reduce(hcat, intb)
end

function neighbours(g, x, y)
    (mx, my) = size(g)
    directions = [(-1, 0), (1, 0), (0, 1), (0, -1)]
    return [(x + a, y + b) for (a, b) in directions if 1 <= x + a <= mx && 1 <= y + b <= my]
end

function dijkstra(grid, from, to)
    to_visit = PriorityQueue{Tuple{Int,Int},Int}()
    visited = zeros(size(grid)...)

    costs = Dict(from => 0)

    enqueue!(to_visit, from => 0)

    while length(to_visit) > 0
        (tx, ty) = dequeue!(to_visit)

        if visited[tx, ty] == 1
            continue
        end

        if (tx, ty) == to
            continue
        end

        visited[tx, ty] = 1

        for (x, y) in neighbours(grid, tx, ty)
            cost = costs[(tx, ty)] + grid[x, y]
            if !haskey(costs, (x, y)) || cost < costs[(x, y)]
                costs[(x, y)] = cost
                enqueue!(to_visit, (x, y) => cost)
            end
        end
    end

    return costs[to...]
end

function part_one(input)
    grid = input_to_matrix(input)
    grid[1, 1] = 0
    return dijkstra(grid, (1, 1), size(grid))
end

function part_two(input)
    grid = input_to_matrix(input)

    (sx, sy) = size(grid)
    ng = zeros(Int, sx * 5, sy * 5)

    ng[1:sx, 1:sy] .= grid
    for i = 1:4
        ng[i*sx+1:(i+1)sx, 1:sy] .= (grid .+ (i - 1)) .% 9 .+ 1
    end

    for i = 1:4
        ng[1:end, i*sy+1:(i+1)sy] .= (ng[1:end, 1:sy] .+ (i - 1)) .% 9 .+ 1
    end

    return dijkstra(ng, (1, 1), size(ng))
end

function test()
    example = """1163751742
1381373672
2136511328
3694931569
7463417111
1319128137
1359912421
3125421639
1293138521
2311944581"""

    @test part_one(example) == 40
    @test part_two(example) == 315
end
