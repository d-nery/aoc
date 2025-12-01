#include <bits/stdc++.h>

#include "../utils/utils.h"

using namespace std;

uint64_t part1(Input input) {
    uint64_t sum = 0;

    for (auto& line : input.lines()) {
        uint64_t secret;
        sscanf(line.c_str(), "%ld", &secret);

        for (int i = 0; i < 2000; i++) {
            secret ^= (secret << 6);
            secret &= 16777215;

            secret ^= (secret >> 5);
            secret &= 16777215;

            secret ^= (secret << 11);
            secret &= 16777215;
        }

        sum += secret;
    }

    return sum;
}

uint64_t part2(Input input) {
    vector<vector<uint8_t>> bananas;
    vector<vector<int8_t>> diffs;

    for (auto& line : input.lines()) {
        uint64_t secret;
        sscanf(line.c_str(), "%ld", &secret);

        vector<uint8_t> _bananas;
        vector<int8_t> _diffs;

        int8_t n = secret % 10;

        for (int i = 0; i < 2000; i++) {
            secret ^= (secret << 6);
            secret &= 16777215;

            secret ^= (secret >> 5);
            secret &= 16777215;

            secret ^= (secret << 11);
            secret &= 16777215;

            int8_t v = secret % 10;
            _bananas.push_back(v);
            _diffs.push_back(v - n);
            n = v;
        }

        bananas.push_back(_bananas);
        diffs.push_back(_diffs);
    }

    using seq_t = tuple<int8_t, int8_t, int8_t, int8_t>;

    map<seq_t, uint64_t> seq_banana;
    for (int i = 0; i < (int)diffs.size(); i++) {
        set<seq_t> visited;

        for (int j = 0; j < 2000 - 3; j++) {
            seq_t s = {diffs[i][j], diffs[i][j + 1], diffs[i][j + 2], diffs[i][j + 3]};
            if (visited.contains(s)) {
                continue;
            }

            visited.emplace(s);
            seq_banana[s] += bananas[i][j + 3];
        }
    }

    uint64_t most = 0;
    for (auto const& [_, v] : seq_banana) {
        most = max(most, v);
    }

    return most;
}

void test() {
    string example = R"(1
10
100
2024)";

    string example2 = R"(1
2
3
2024)";

    assert(part1(Input::from_raw(example)) == 37327623);
    assert(part2(Input::from_raw(example2)) == 23);
}
