using Test
using DataStructures

function part_one(input)
    cubes = map(c -> parse.(Int, c), split.(split(input, "\n"), ","))

    f = 0
    for c in cubes
        sides = 6
        for c2 in cubes
            if sum(abs.(c2 .- c)) == 1
                sides -= 1
            end
        end
        f += sides
    end

    return f
end

const directions = [(1, 0, 0), (0, 1, 0), (0, 0, 1), (-1, 0, 0), (0, -1, 0), (0, 0, -1)]

function part_two(input)
    cubes = Tuple.(map(c -> parse.(Int, c), split.(split(input, "\n"), ",")))

    ((minx, maxx), (miny, maxy), (minz, maxz)) = ((999999, 0), (999999, 0), (999999, 0))

    for c in cubes
        minx = min(minx, c[1] - 1)
        maxx = max(maxx, c[1] + 1)
        miny = min(miny, c[2] - 1)
        maxy = max(maxy, c[2] + 1)
        minz = min(minz, c[3] - 1)
        maxz = max(maxz, c[3] + 1)
    end

    visited_out = Set{Tuple{Int,Int,Int}}()

    # Flood fill until an outer point is reached (or it ends, then it's inside)
    reaches_outside = (x, y, z) -> begin
        if (x, y, z) in cubes
            return false
        end

        # save points already known to be outside
        visited = Set{Tuple{Int,Int,Int}}()
        Q = Queue{Tuple{Int,Int,Int}}()
        enqueue!(Q, (x, y, z))

        while !isempty(Q)
            (x, y, z) = dequeue!(Q)
            if (x, y, z) in visited
                continue
            end

            push!(visited, (x, y, z))
            if (x, y, z) in visited_out ||
               x < minx || x > maxx || y < miny || y > maxy || z < minz || z > maxz
                union!(visited_out, setdiff(visited, cubes))
                return true
            end

            if !((x, y, z) in cubes)
                for dir in directions
                    enqueue!(Q, Tuple([x, y, z] .+ dir))
                end
            end
        end

        return false
    end

    sides = 0
    for c in cubes
        for dir in directions
            if reaches_outside((c .+ dir)...)
                sides += 1
            end
        end
    end

    return sides
end

function test()
    example = """2,2,2
1,2,2
3,2,2
2,1,2
2,3,2
2,2,1
2,2,3
2,2,4
2,2,6
1,2,5
3,2,5
2,1,5
2,3,5"""

    @test part_one(example) == 64
    @test part_two(example) == 58
end
