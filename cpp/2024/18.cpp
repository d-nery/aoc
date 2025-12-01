#include <bits/stdc++.h>
#include <ranges>

#include "../utils/utils.h"

using namespace std;

// 7 for example, 71 for input
// constexpr size_t SIZE = 7;
constexpr size_t SIZE = 71;
// 12 for example, 1024 for input
// constexpr int BYTES = 12;
constexpr int BYTES = 1024;

int64_t flood_fill(Grid<char> const& grid, Point const& start, Point const& target) {
    Grid<int64_t> distances(SIZE, SIZE, -1);
    distances[target] = 0;

    queue<Point> to_visit;
    to_visit.push(target);

    while (!to_visit.empty()) {
        auto pos = to_visit.front();
        to_visit.pop();

        for (auto& dir : directions) {
            auto next = pos + dir;

            if (!grid.is_inside(next) || grid[next] == '#') {
                continue;
            }

            // already visited;
            if (distances[next] != -1) {
                continue;
            };

            distances[next] = distances[pos] + 1;
            to_visit.push(next);
        }
    }

    // distances.dump_s();

    return distances[start];
}

uint64_t part1(Input input) {
    auto lines = input.lines();

    Grid mem_space(SIZE, SIZE, '.');
    for (int i = 0; i < BYTES; i++) {
        Point c;
        sscanf(lines[i].c_str(), "%d,%d", &c.x, &c.y);
        mem_space[c] = '#';
    }

    // mem_space.dump();

    return flood_fill(mem_space, {0, 0}, {SIZE - 1, SIZE - 1});
}

uint64_t part2(Input input) {
    auto lines = input.lines();

    Grid mem_space(SIZE, SIZE, '.');
    for (int i = 0; i < BYTES; i++) {
        Point c;
        sscanf(lines[i].c_str(), "%d,%d", &c.x, &c.y);
        mem_space[c] = '#';
    }

    for (size_t i = BYTES; i < lines.size(); i++) {
        Point c;
        sscanf(lines[i].c_str(), "%d,%d", &c.x, &c.y);
        mem_space[c] = '#';

        if (flood_fill(mem_space, {0, 0}, {SIZE - 1, SIZE - 1}) == -1) {
            cout << "Found: " << lines[i] << endl;
            return 0;
        }
    };

    return -1;
}

void test() {
    string example = R"(5,4
4,2
4,5
3,0
2,1
6,3
2,4
1,5
0,6
3,3
2,6
5,1
1,2
5,5
2,5
6,5
1,4
0,4
6,4
1,1
6,1
1,0
0,5
1,6
2,0)";

    assert(part1(Input::from_raw(example)) == 22);
    assert(part2(Input::from_raw(example)) == 0);
}
