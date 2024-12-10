#include <bits/stdc++.h>

#include "../utils/utils.h"

using namespace std;

using Grid = vector<string>;

struct Point {
    int x, y;

    Point operator+(const Point& other) const { return Point{x + other.x, y + other.y}; }
    Point operator-(const Point& other) { return Point{x - other.x, y - other.y}; }
    string to_string() const { return format("{},{}", x, y); }
};

constexpr array<Point, 4> directions = {Point{-1, 0}, Point{0, 1}, Point{1, 0}, Point{0, -1}};
constexpr inline bool is_inside(Grid const& grid, Point const& point) {
    int max_i = grid.size();
    int max_j = grid[0].length();

    return point.x >= 0 && point.x < max_i && point.y >= 0 && point.y < max_j;
}

static bool consider_visited = true;
int points(Grid& grid, Point const& from, set<string>& visited) {
    if (consider_visited) {
        visited.emplace(from.to_string());
    }

    if (grid[from.x][from.y] == '9') {
        return 1;
    }

    vector<Point> to_visit;
    for (auto& dir : directions) {
        auto next = from + dir;

        if (!is_inside(grid, next)) {
            continue;
        }

        if (grid[next.x][next.y] - grid[from.x][from.y] != 1) {
            continue;
        }

        if (consider_visited && visited.contains(next.to_string())) {
            continue;
        }

        to_visit.push_back(next);
    }

    int sum = 0;

    for (auto& p : to_visit) {
        sum += points(grid, p, visited);
    }

    return sum;
}

int part1(Input input) {
    auto grid = input.lines();

    int max_i = grid.size();
    int max_j = grid[0].length();

    int sum = 0;

    for (int i = 0; i < max_i; i++) {
        for (int j = 0; j < max_j; j++) {
            if (grid[i][j] == '0') {
                set<string> visited;
                sum += points(grid, Point{i, j}, visited);
            }
        }
    }

    return sum;
}

int part2(Input input) {
    consider_visited = false;
    return part1(input);
}

void test() {
    string example = R"(89010123
78121874
87430965
96549874
45678903
32019012
01329801
10456732)";

    assert(part1(Input::from_raw(example)) == 36);
    assert(part2(Input::from_raw(example)) == 81);
}
