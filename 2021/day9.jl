using Test
using DataStructures

function input_to_matrix(input)
    b = split.(strip.(split(input, "\n")), "")
    intb = map(c -> parse.(Int, c), b)

    return reduce(hcat, intb)
end

function get_value(matrix, x, y)
    return get(matrix, (x, y), 10)
end

function get_mins(matrix)
    (mins, idx) = ([], [])
    (r, c) = size(matrix)
    for i = 1:r
        for j = 1:c
            n = get_value(matrix, i, j)
            if (get_value(matrix, i, j - 1) > n &&
                get_value(matrix, i, j + 1) > n &&
                get_value(matrix, i - 1, j) > n &&
                get_value(matrix, i + 1, j) > n)

                push!(mins, n)
                push!(idx, (i, j))
            end
        end
    end
    return (mins, idx)
end

function part_one(input)
    m = input_to_matrix(input)

    (mins, _) = get_mins(m)

    return sum(mins .+ 1)
end

function bfs(matrix, start_idx)
    directions = [(-1, 0), (1, 0), (0, 1), (0, -1)]

    (x, y) = start_idx

    to_visit = Deque{Tuple{Int,Int}}()
    visited = zeros(size(matrix)...)

    push!(to_visit, (x, y))
    visited[x, y] = 1

    while length(to_visit) > 0
        (i, j) = popfirst!(to_visit)
        v = get_value(matrix, i, j)
        for (dx, dy) in directions
            if get_value(visited, i + dx, j + dy) == 0
                next_v = get_value(matrix, i + dx, j + dy)
                if v < next_v < 9
                    visited[i+dx, j+dy] = 1
                    push!(to_visit, (i + dx, j + dy))
                end
            end
        end
    end

    return visited
end

function part_two(input)
    m = input_to_matrix(input)
    (_, idx) = get_mins(m)

    sizes = []
    for i in idx
        v = bfs(m, i)
        push!(sizes, length(filter(n -> n == 1, v)))
    end

    sort!(sizes)

    return prod(sizes[end-2:end])
end

function test()
    example = """2199943210
3987894921
9856789892
8767896789
9899965678"""

    @test part_one(example) == 15
    @test part_two(example) == 1134
end
