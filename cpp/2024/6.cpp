#include <bits/stdc++.h>

#include "../utils/utils.h"

using namespace std;

using Grid = vector<string>;

struct Point {
    int x, y;

    Point operator+(const Point& other) { return Point{x + other.x, y + other.y}; }
    string to_string(string dir = "") { return format("{},{}{}", x, y, dir); }
};

constexpr array<Point, 4> directions = {Point{-1, 0}, Point{0, 1}, Point{1, 0}, Point{0, -1}};
constexpr array<string, 4> dirnames = {"N", "E", "S", "W"};

static set<string> g_visited;

Point find_start_position(Grid const& grid) {
    int max_i = grid.size();
    int max_j = grid[0].length();

    for (int i = 0; i < max_i; i++) {
        for (int j = 0; j < max_j; j++) {
            if (grid[i][j] == '^') {
                return Point{i, j};
            }
        }
    }

    return Point{};
}

constexpr inline bool is_inside(Grid const& grid, Point const& point) {
    int max_i = grid.size();
    int max_j = grid[0].length();

    return point.x >= 0 && point.x < max_i && point.y >= 0 && point.y < max_j;
}

int part1(Input input) {
    auto grid = input.lines();

    int dir = 0;
    set<string> visited;

    Point pos = find_start_position(grid);

    visited.emplace(pos.to_string());

    while (true) {
        auto new_pos = pos + directions[dir];

        // OOB
        if (!is_inside(grid, new_pos)) {
            break;
        }

        if (grid[new_pos.x][new_pos.y] == '#') {
            dir = (dir + 1) % 4;
            continue;
        }

        visited.emplace(new_pos.to_string());
        pos = new_pos;
    }

    // For part 2
    g_visited = visited;
    return visited.size();
}

bool has_loop(Grid const& grid, Point const& start_pos) {
    set<string> visited;
    int dir = 0;
    auto pos = start_pos;

    visited.emplace(pos.to_string(dirnames[dir]));

    while (true) {
        auto new_pos = pos + directions[dir];

        // OOB
        if (!is_inside(grid, new_pos)) {
            return false;
        }

        if (grid[new_pos.x][new_pos.y] == '#') {
            dir = (dir + 1) % 4;
            continue;
        }

        if (visited.contains(new_pos.to_string(dirnames[dir]))) {
            return true;
        }

        visited.emplace(new_pos.to_string(dirnames[dir]));
        pos = new_pos;
    }
}

int part2(Input input) {
    part1(input);

    // Try putting obstacle every where guard goes through
    int loops = 0;
    auto start_pos = find_start_position(input.lines());

    cout << "Trying obstacle in " << g_visited.size() << " positions" << endl;

    int cnt = 0;
    for (auto& position : g_visited) {
        int i, j;
        sscanf(position.c_str(), "%d,%d", &i, &j);

        if (i == start_pos.x && j == start_pos.y) {
            continue;
        }

        auto grid = input.lines();
        grid[i][j] = '#';

        if (has_loop(grid, start_pos)) {
            loops++;
        }

        if (++cnt % 1000 == 0) {
            cout << "Done " << cnt << " simulations! Loops: " << loops << endl;
        }
    }

    return loops;
}

void test() {
    string example = R"(....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#...)";

    assert(part1(Input::from_raw(example)) == 41);
    assert(part2(Input::from_raw(example)) == 6);
}
