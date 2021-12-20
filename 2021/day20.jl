using Test

function process(algo, image, default = 0)
    default = algo[1] == '.' ? 0 : default

    new_image = Dict()
    min_i = 1000
    max_i = -1000
    min_j = 1000
    max_j = -1000

    for (i, j) in keys(image)
        min_i = min(i, min_i)
        min_j = min(j, min_j)
        max_i = max(i, max_i)
        max_j = max(j, max_j)
    end

    for i = min_i-1:max_i+1
        for j = min_j-1:max_j+1
            n::UInt16 = 0
            for a = i-1:i+1
                for b = j-1:j+1
                    n <<= 1
                    n |= get(image, (a, b), default)
                end
            end

            new_image[(i, j)] = algo[n+1] == '#' ? 1 : 0
        end
    end

    return new_image
end

function part_one(input, times = 2)
    (algo, image) = split(input, "\n\n")

    image = split(image, "\n")

    image_dict = Dict()

    for i = 1:length(image)
        for j = 1:length(image[1])
            image_dict[(i, j)] = image[i][j] == '#' ? 1 : 0
        end
    end

    for a = 0:times-1
        image_dict = process(algo, image_dict, a % 2)
    end

    return reduce(+, values(image_dict))
end

function part_two(input)
    return part_one(input, 50)
end

function test()
    example = """..#.#..#####.#.#.#.###.##.....###.##.#..###.####..#####..#....#..#..##..###..######.###...####..#..#####..##..#.#####...##.#.#..#.##..#.#......#.###.######.###.####...#.##.##..#..#..#####.....#.#....###..#.##......#.....#..#..#..##..#...##.######.####.####.#.#...#.......#..#.#.#...####.##.#......#..#...##.#.##..#...##.#.##..###.#......#.#.......#.#.#.####.###.##...#.....####.#..#..#.##.#....##..#.####....##...##..#...#......#.#.......#.......##..####..#...#.#.#...##..#.#..###..#####........#..####......#..#

#..#.
#....
##..#
..#..
..###"""

    @test part_one(example) == 35
    @test part_two(example) == 3351
end
