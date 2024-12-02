#include <bits/stdc++.h>
#include <ranges>

#include "../utils/utils.h"

using namespace std;

bool is_safe(vector<int> v, int ignore_idx = -1) {
    int direction = 0;
    for (int i = 1; i < (int)v.size(); i++) {
        if (i == ignore_idx || (ignore_idx == 0 && i == 1)) {
            continue;
        }

        int dir = v[i] - v[i - 1];

        if (i - 1 == ignore_idx) {
            dir = v[i] - v[i - 2];
        }

        if (abs(dir) > 3 || dir == 0) {
            return false;
        }

        if (dir * direction < 0) {
            return false;
        }

        direction = dir;
    }

    return true;
}

int part1(Input input) {
    int safe = 0;

    for (auto& line : input.lines()) {
        stringstream s(line);

        int n;
        vector<int> v;
        while (s >> n) {
            v.push_back(n);
        }

        if (is_safe(v)) {
            safe++;
        }
    }

    return safe;
}

int part2(Input input) {
    int safe = 0;

    for (auto& line : input.lines()) {
        stringstream s(line);

        int n;
        vector<int> v;
        while (s >> n) {
            v.push_back(n);
        }

        for (int i = -1; i < (int)v.size(); i++) {
            if (is_safe(v, i)) {
                safe++;
                break;
            }
        }
    }

    return safe;
}

void test() {
    string example = R"(7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9)";

    assert(part1(Input::from_raw(example)) == 2);
    assert(part2(Input::from_raw(example)) == 4);
}
