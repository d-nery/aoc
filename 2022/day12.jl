using Test
using DataStructures

function parse_grid(input)
    raw_grid = split.(split(input, "\n"), "")
    grid = only.(mapreduce(permutedims, vcat, raw_grid))

    start_pos = findfirst(c -> c == 'S', grid)
    target_pos = findfirst(c -> c == 'E', grid)

    grid[start_pos] = 'a'
    grid[target_pos] = 'z'

    return (grid, start_pos, target_pos)
end

function neighbours(g, x, y)
    (mx, my) = size(g)
    directions = [(-1, 0), (1, 0), (0, 1), (0, -1)]
    return [(x + a, y + b) for (a, b) in directions if 1 <= x + a <= mx && 1 <= y + b <= my]
end

# Slightly changed from 2021/day15 to stop on impossible paths and accept multiple starting points
function dijkstra(grid, froms, to)
    to_visit = PriorityQueue{Tuple{Int,Int},Int}()
    visited = zeros(size(grid)...)

    costs = Dict{Tuple{Int,Int},Int}()

    for from in froms
        costs[from] = 0
        enqueue!(to_visit, from => 0)
    end

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
            if (grid[tx, ty] < (grid[x, y] - 1))
                continue
            end
            cost = costs[(tx, ty)] + 1

            if !haskey(costs, (x, y)) || cost < costs[(x, y)]
                costs[(x, y)] = cost
                enqueue!(to_visit, (x, y) => cost)
            end
        end
    end

    return costs[to]
end

function part_one(input)
    (grid, start_pos, target_pos) = parse_grid(input)
    return dijkstra(grid, [Tuple(start_pos)], Tuple(target_pos))
end

function part_two(input)
    (grid, _, target_pos) = parse_grid(input)
    froms = map(Tuple, findall((p) -> p == 'a', grid))
    return dijkstra(grid, froms, Tuple(target_pos))
end

function test()
    example = """Sabqponm
abcryxxl
accszExk
acctuvwj
abdefghi"""

    @test part_one(example) == 31
    @test part_two(example) == 29
end
