using Test
using Printf
using ResumableFunctions

const manhattan = (p1, p2) -> sum(abs.(p1 .- p2))

function extract(line)
    (sensor, beacon) = split(line, ": ")
    ((_, sx), (_, sy)) = split.(split(sensor[11:end], ", "), "=")
    ((_, bx), (_, by)) = split.(split(beacon[22:end], ", "), "=")

    return (parse.(Int, (sx, sy)), parse.(Int, (bx, by)))
end

function part_one(input, row_to_check=2000000)
    no_beacons = Set{Tuple{Int,Int}}()
    beacons = Set{Tuple{Int,Int}}()

    for line in split(input, "\n")
        (sensor, beacon) = extract(line)
        push!(beacons, beacon)
        distance = manhattan(sensor, beacon)

        for dx in (-1, 1)
            (sx, _) = sensor
            dist = manhattan(sensor, (sx, row_to_check))
            while dist <= distance
                push!(no_beacons, (sx, row_to_check))
                sx += dx
                dist += 1
            end
        end
    end

    return length(setdiff(no_beacons, beacons))
end

@resumable function points_off_range(point, distance)
    (px, py) = point
    px += distance + 1

    @yield (px, py)
    while px > point[1]
        px -= 1
        py += 1
        @yield (px, py)
    end

    while px > point[1] - distance - 1
        px -= 1
        py -= 1
        @yield (px, py)
    end

    while px < point[1]
        px += 1
        py -= 1
        @yield (px, py)
    end

    while px < point[1] + distance + 1
        px += 1
        py += 1
        @yield (px, py)
    end
end

function part_two(input, limit=4000000)
    sensors = Dict{Tuple{Int,Int},Int}()

    for line in split(input, "\n")
        (sensor, beacon) = extract(line)
        d = manhattan(sensor, beacon)
        sensors[sensor] = d
    end

    for sensor in keys(sensors)
        for point in points_off_range(sensor, sensors[sensor])
            if !(0 <= point[1] <= limit && 0 <= point[2] <= limit)
                continue
            end

            found = true
            for s in keys(sensors)
                if manhattan(s, point) <= sensors[s]
                    found = false
                    break
                end
            end
            if found
                return point[1] * 4_000_000 + point[2]
            end
        end
    end

    return -1
end

function test()
    example = """Sensor at x=2, y=18: closest beacon is at x=-2, y=15
Sensor at x=9, y=16: closest beacon is at x=10, y=16
Sensor at x=13, y=2: closest beacon is at x=15, y=3
Sensor at x=12, y=14: closest beacon is at x=10, y=16
Sensor at x=10, y=20: closest beacon is at x=10, y=16
Sensor at x=14, y=17: closest beacon is at x=10, y=16
Sensor at x=8, y=7: closest beacon is at x=2, y=10
Sensor at x=2, y=0: closest beacon is at x=2, y=10
Sensor at x=0, y=11: closest beacon is at x=2, y=10
Sensor at x=20, y=14: closest beacon is at x=25, y=17
Sensor at x=17, y=20: closest beacon is at x=21, y=22
Sensor at x=16, y=7: closest beacon is at x=15, y=3
Sensor at x=14, y=3: closest beacon is at x=15, y=3
Sensor at x=20, y=1: closest beacon is at x=15, y=3"""

    @test part_one(example, 10) == 26
    @test part_two(example, 20) == 56000011
end
