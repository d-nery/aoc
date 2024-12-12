#include <bits/stdc++.h>
#include <ranges>

#include "../utils/utils.h"

using namespace std;

using Grid = vector<string>;

struct Point {
    int x, y;

    Point operator+(const Point& other) const { return Point{x + other.x, y + other.y}; }
    Point operator-(const Point& other) { return Point{x - other.x, y - other.y}; }
    auto operator<=>(const Point& other) const { return pair{x, y} <=> pair{other.x, other.y}; }
    string to_string() const { return format("{},{}", x, y); }
};

constexpr array<Point, 4> directions = {Point{-1, 0}, Point{0, 1}, Point{1, 0}, Point{0, -1}};
constexpr array<Point, 4> diagonals = {Point{-1, -1}, Point{-1, 1}, Point{1, 1}, Point{1, -1}};
constexpr inline bool is_inside(Grid const& grid, Point const& point) {
    int max_i = grid.size();
    int max_j = grid[0].length();

    return point.x >= 0 && point.x < max_i && point.y >= 0 && point.y < max_j;
}

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
uint64_t fence(Grid const& grid, Point& where, set<Point>& visited) {
    queue<Point> to_visit;
    to_visit.emplace(where);

    set<Point> region_points;

    uint64_t perimeter = 0;
    uint64_t area = 0;

    char region = grid[where.x][where.y];

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

            if (!is_inside(grid, next)) {
                perimeter += 1;
                continue;
            }

            if (grid[next.x][next.y] != region) {
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
    auto grid = input.lines();

    const int max_i = grid.size();
    const int max_j = grid[0].length();
    const size_t total = max_i * max_j;

    set<Point> visited;
    queue<Point> to_visit;
    to_visit.emplace(Point{0, 0});

    int sum = 0;
    while (visited.size() != total) {
        Point next{-1, -1};
        for (int i = 0; i < max_i && next.x == -1; i++) {
            for (int j = 0; j < max_j && next.x == -1; j++) {
                if (!visited.contains(Point{i, j})) {
                    next.x = i;
                    next.y = j;
                }
            }
        }

        sum += fence(grid, next, visited);
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
