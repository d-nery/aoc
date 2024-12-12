#include <bits/stdc++.h>
#include <ranges>

#include "../utils/grid.h"
#include "../utils/utils.h"

using namespace std;

constexpr array<Point, 3> NE = {Point{-1, 0}, Point{-1, 1}, Point{0, 1}};
constexpr array<Point, 3> NW = {Point{-1, 0}, Point{-1, -1}, Point{0, -1}};
constexpr array<Point, 3> SW = {Point{1, 0}, Point{1, -1}, Point{0, -1}};
constexpr array<Point, 3> SE = {Point{1, 0}, Point{1, 1}, Point{0, 1}};
constexpr array<array<Point, 3>, 4> corners = {NE, NW, SW, SE};

uint64_t get_sides(set<Point>& polygon) {
    uint8_t sides = 0;

    for (auto& p : polygon) {
        for (auto& corner : corners) {
            // Inner corners
            sides += polygon.contains(p + corner[0]) && !polygon.contains(p + corner[1]) && polygon.contains(p + corner[2]);

            // Outer corners
            sides += !polygon.contains(p + corner[0]) && !polygon.contains(p + corner[2]);
        }
    }

    return sides;
}

static bool use_sides = false;
uint64_t fence(Grid<char>& grid, Point const& where, set<Point>& visited) {
    queue<Point> to_visit;
    to_visit.emplace(where);

    set<Point> region_points;

    uint64_t perimeter = 0;
    uint64_t area = 0;

    char region = grid[where];

    while (!to_visit.empty()) {
        auto point = to_visit.front();
        to_visit.pop();

        if (visited.contains(point)) {
            continue;
        }

        visited.emplace(point);
        region_points.emplace(point);

        area += 1;
        for (auto& dir : directions) {
            auto next = point + dir;

            if (!grid.is_inside(next)) {
                perimeter += 1;
                continue;
            }

            if (grid[next] != region) {
                perimeter += 1;
                continue;
            }

            if (visited.contains(next)) {
                continue;
            }

            to_visit.emplace(next);
        }
    }

    if (use_sides) {
        perimeter = get_sides(region_points);
    }

    return perimeter * area;
}

uint64_t part1(Input input) {
    auto grid = input.grid();

    const auto size = grid.size();
    const size_t total = size.first * size.second;

    set<Point> visited;
    queue<Point> to_visit;
    to_visit.emplace(Point{0, 0});

    int sum = 0;
    while (visited.size() != total) {
        for (auto const& [_, point] : grid) {
            if (!visited.contains(point)) {
                sum += fence(grid, point, visited);
            }
        }
    }

    return sum;
}

uint64_t part2(Input input) {
    use_sides = true;
    return part1(input);
}

void test() {
    string example = R"(AAAA
BBCD
BBCC
EEEC)";

    string example2 = R"(RRRRIICCFF
RRRRIICCCF
VVRRRCCFFF
VVRCCCJFFF
VVVVCJJCFE
VVIVCCJJEE
VVIIICJJEE
MIIIIIJJEE
MIIISIJEEE
MMMISSJEEE)";

    string example3 = R"(AAAAAA
AAABBA
AAABBA
ABBAAA
ABBAAA
AAAAAA)";

    assert(part1(Input::from_raw(example)) == 140);
    assert(part1(Input::from_raw(example2)) == 1930);
    assert(part2(Input::from_raw(example)) == 80);
    assert(part2(Input::from_raw(example2)) == 1206);
    assert(part2(Input::from_raw(example3)) == 368);
}
