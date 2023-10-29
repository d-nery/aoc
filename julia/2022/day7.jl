using Test

function get_directory_sizes(input)
    commands = split(input, "\n")
    directories = Dict{String,Int64}()

    cmd_idx = 1
    curr_dir = ["/"]
    while cmd_idx < length(commands)
        cmd = strip(commands[cmd_idx])
        if startswith(cmd, raw"$ ")
            c = split(cmd[3:end], " ")
            if c[1] == "cd"
                if c[2] == "/"
                    curr_dir = ["/"]
                elseif c[2] == ".."
                    pop!(curr_dir)
                else
                    push!(curr_dir, c[2])
                end
                cmd_idx += 1
                continue
            end

            if c[1] == "ls"
                path = join(curr_dir, ";") # No / in case I needed to split it again
                directories[path] = 0
                while cmd_idx < length(commands)
                    cmd_idx += 1
                    cmd = strip(commands[cmd_idx])

                    if startswith(cmd, "dir")
                        continue
                    end

                    if startswith(cmd, raw"$ ")
                        break
                    end

                    (size, _) = split(cmd, " ")
                    directories[path] += parse(Int64, size)
                end
            end
        end
    end

    dirs = collect(keys(directories))

    sizes = Dict{String,Int64}()

    for dir in dirs
        sizes[dir] = 0
        for subd in filter(d -> startswith(d, dir), dirs)
            sizes[dir] += directories[subd]
        end
    end

    return sizes
end

function part_one(input)
    sizes = get_directory_sizes(input)
    return sum(filter(s -> s <= 100_000, collect(values(sizes))))
end

function part_two(input)
    sizes = get_directory_sizes(input)

    total_space = 70_000_000
    needed_unused = 30_000_000
    used = sizes["/"]
    free = total_space - used
    need_to_free = needed_unused - free

    return min(filter(s -> s >= need_to_free, collect(values(sizes)))...)
end

function test()
    example = raw"""$ cd /
$ ls
dir a
14848514 b.txt
8504156 c.dat
dir d
$ cd a
$ ls
dir e
29116 f
2557 g
62596 h.lst
$ cd e
$ ls
584 i
$ cd ..
$ cd ..
$ cd d
$ ls
4060174 j
8033020 d.log
5626152 d.ext
7214296 k"""

    @test part_one(example) == 95437
    @test part_two(example) == 24933642
end
