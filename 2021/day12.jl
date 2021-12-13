using Test
using DataStructures

function parse_paths(input)
    paths = split(input, "\n")

    path = Dict{String,Set{String}}()

    for p in paths
        (p1, p2) = split(p, "-")
        if !haskey(path, p1)
            path[p1] = Set()
        end

        if !haskey(path, p2)
            path[p2] = Set()
        end

        push!(path[p1], p2)
        push!(path[p2], p1)
    end

    return path
end

function search(paths, from, to, visited, double_visit = false)
    if from == to
        return 1
    end

    counter = 0

    for p in paths[from]
        if all(islowercase, p)
            if !(p in visited)
                counter += search(paths, p, to, visited ∪ Set([p]), double_visit)
            elseif double_visit && p != "start"
                counter += search(paths, p, to, visited ∪ Set([p]), false)
            end
        else
            counter += search(paths, p, to, visited, double_visit)
        end
    end

    return counter
end

function part_one(input)
    paths = parse_paths(input)
    visited = Set(["start"])
    return search(paths, "start", "end", visited)
end

function part_two(input)
    paths = parse_paths(input)
    visited = Set(["start"])
    return search(paths, "start", "end", visited, true)
end

function test()
    example = """start-A
start-b
A-c
A-b
b-d
A-end
b-end"""

    example2 = """dc-end
HN-start
start-kj
dc-start
dc-HN
LN-dc
HN-end
kj-sa
kj-HN
kj-dc"""

    example3 = """fs-end
he-DX
fs-he
start-DX
pj-DX
end-zg
zg-sl
zg-pj
pj-he
RW-he
fs-DX
pj-RW
zg-RW
start-pj
he-WI
zg-he
pj-fs
start-RW"""

    @test part_one(example) == 10
    @test part_one(example2) == 19
    @test part_one(example3) == 226
    @test part_two(example) == 36
    @test part_two(example2) == 103
    @test part_two(example3) == 3509
end
