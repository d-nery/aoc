#include <bits/stdc++.h>

#include "../utils/utils.h"

using namespace std;

void dbg_print_grid(Grid<char>& grid, Point const& point);
void dbg_print_grid(Grid<char>& grid, set<Point> const& points);
void dbg_print_queue(deque<tuple<Point, char, uint64_t>>& to_visit);

uint64_t find_cost(Grid<char>& grid, Point const& from, Point const& to) {
    map<Point, uint64_t> visited;

    // coord, direction, value
    deque<tuple<Point, char, uint64_t>> to_visit;

    to_visit.push_back({from, 'E', 0});

    while (!to_visit.empty()) {
        auto [point, current_dir, cost] = to_visit.front();
        to_visit.pop_front();

        if (visited.contains(point) && visited[point] <= cost) {
            continue;
        }

        visited[point] = cost;

        // dbg_print_grid(grid, point, visited);

        for (auto const& [d, dir] : direction_map) {
            auto next = point + dir;

            if (grid[next] == '#') {
                continue;
            }

            if (current_dir == d) {
                to_visit.push_back({next, d, 1 + cost});
                continue;
            }

            if ((current_dir == 'N' || current_dir == 'S') && (d == 'E' || d == 'W')) {
                to_visit.push_back({next, d, 1001 + cost});
                continue;
            }

            if ((current_dir == 'E' || current_dir == 'W') && (d == 'N' || d == 'S')) {
                to_visit.push_back({next, d, 1001 + cost});
                continue;
            }
        }

        // dbg_print_queue(to_visit);
    }

    return visited[to];
}

uint64_t part1(Input input) {
    auto grid = input.grid();

    Point start, end;
    for (auto const& [c, p] : grid) {
        if (c == 'S') {
            start = p;
        }

        if (c == 'E') {
            end = p;
        }
    }

    return find_cost(grid, start, end);
}

// Direction, values
uint64_t find_paths(Grid<char>& grid, Point const& from, Point const& to, uint64_t const best) {
    map<pair<Point, char>, uint64_t> visited;
    visited.clear();

    // coord, direction, value, path
    deque<tuple<Point, char, uint64_t, set<Point>>> to_visit;

    to_visit.push_back({from, 'E', 0, {from}});

    set<Point> paths;

    while (!to_visit.empty()) {
        auto [point, current_dir, cost, path] = to_visit.front();
        to_visit.pop_front();

        if (cost > best) {
            continue;
        }

        if (point == to) {
            if (cost == best) {
                paths.merge(path);
                // dbg_print_grid(grid, paths);
            }

            continue;
        }

        for (auto const& [d, dir] : direction_map) {
            auto next = point + dir;
            auto dcost = cost;

            if (grid[next] == '#') {
                continue;
            }

            if (current_dir == d) {
                dcost += 1;
            } else if ((current_dir == 'N' || current_dir == 'S') && (d == 'E' || d == 'W')) {
                dcost += 1001;
            } else if ((current_dir == 'E' || current_dir == 'W') && (d == 'N' || d == 'S')) {
                dcost += 1001;
            } else {
                continue; // backwards
            }

            if (visited.contains({point, d}) && visited[{point, d}] < dcost) {
                continue;
            }

            visited[{point, d}] = dcost;

            auto npath = set<Point>(path);
            npath.emplace(next);
            to_visit.push_back({next, d, dcost, npath});
        }
    }

    return paths.size();
}

uint64_t part2(Input input) {
    auto best = part1(input);

    auto grid = input.grid();
    Point start, end;
    for (auto const& [c, p] : grid) {
        if (c == 'S') {
            start = p;
        }

        if (c == 'E') {
            end = p;
        }
    }

    return find_paths(grid, start, end, best);
}

void test() {
    string example = R"(###############
#.......#....E#
#.#.###.#.###.#
#.....#.#...#.#
#.###.#####.#.#
#.#.#.......#.#
#.#.#####.###.#
#...........#.#
###.#.#####.#.#
#...#.....#.#.#
#.#.#.###.#.#.#
#.....#...#.#.#
#.###.#.#.#.#.#
#S..#.....#...#
###############)";

    string example2 = R"(#################
#...#...#...#..E#
#.#.#.#.#.#.#.#.#
#.#.#.#...#...#.#
#.#.#.#.###.#.#.#
#...#.#.#.....#.#
#.#.#.#.#.#####.#
#.#...#.#.#.....#
#.#.#####.#.###.#
#.#.#.......#...#
#.#.###.#####.###
#.#.#...#.....#.#
#.#.#.#####.###.#
#.#.#.........#.#
#.#.#.#########.#
#S#.............#
#################)";

    assert(part1(Input::from_raw(example)) == 7036);
    assert(part1(Input::from_raw(example2)) == 11048);
    assert(part2(Input::from_raw(example)) == 45);
    assert(part2(Input::from_raw(example2)) == 64);
}

void dbg_print_grid(Grid<char>& grid, Point const& point, map<Point, uint64_t> visited) {
    for (int i = -1; i < grid.size().first; i++) {
        if (i >= 0) {
            print("{:-2d} ", i);
        }
        for (int j = -1; j < grid.size().second; j++) {
            if (i == -1) {
                if (j >= 0) {
                    print("  {:-2d}  ", j);
                } else {
                    print("   ");
                }
                continue;
            }

            if (j == -1) {
                continue;
            }

            auto cd = Point{i, j};
            if (grid[cd] == '#') {
                print("[####]");
                continue;
            }

            if (point == cd) {
                print("\033[38;5;76m[{:04d}]\033[0m", visited[cd]);
                continue;
            }

            if (!visited.contains(cd)) {
                print("[   ?]");
                continue;
            }

            print("[{:04d}]", visited[cd]);
        }
        println();
    }
}

void dbg_print_grid(Grid<char>& grid, set<Point> const& points) {
    for (int i = -1; i < grid.size().first; i++) {
        if (i >= 0) {
            print("{:-2d} ", i);
        }
        for (int j = -1; j < grid.size().second; j++) {
            if (i == -1) {
                if (j >= 0) {
                    print("  {:-2d}  ", j);
                } else {
                    print("   ");
                }
                continue;
            }

            if (j == -1) {
                continue;
            }

            auto cd = Point{i, j};
            if (grid[cd] == '#') {
                print("[####]");
                continue;
            }

            if (points.contains(cd)) {
                print("\033[38;5;76m[ p  ]\033[0m");
                continue;
            }

            print("[    ]");
        }
        println();
    }
}

void dbg_print_queue(deque<tuple<Point, char, uint64_t>>& to_visit) {
    print("Queue:");
    for (auto& [tv, d, c] : to_visit) {
        print(" {},{},{} |", tv.to_string(), d, c);
    }
    println();
}
