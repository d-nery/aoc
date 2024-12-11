#include <bits/stdc++.h>

#include "../utils/utils.h"

using namespace std;

uint64_t part1(Input input) {
    auto disk = input.lines()[0];

    vector<int> expanded;

    int id = 0;
    int free_idx = disk[0] - '0';

    for (int i = 0; i < (int)disk.length(); i++) {
        int size = disk[i] - '0';

        for (int j = 0; j < size; j++) {
            // disk
            if (!(i & 1)) {
                expanded.push_back(id);
            } else {
                expanded.push_back(-1);
            }
        }

        if ((i & 1) == 0) {
            id++;
        }
    }

    int last_idx = expanded.size() - 1;

    while (last_idx > free_idx) {
        expanded[free_idx++] = expanded[last_idx];
        expanded[last_idx--] = -1;

        while (expanded[free_idx] != -1) {
            free_idx++;
        }

        while (expanded[last_idx] == -1) {
            last_idx--;
        }
    }

    uint64_t checksum = 0;

    int chk_idx = 0;
    while (expanded[chk_idx] != -1) {
        checksum += chk_idx * expanded[chk_idx];
        chk_idx++;
    }

    cout << checksum << endl;

    return checksum;
}

uint64_t part2(Input input) {
    auto disk = input.lines()[0];

    // [id, size]
    vector<pair<int, int>> blocks;

    int id = 0;
    for (int i = 0; i < (int)disk.length(); i++) {
        int size = disk[i] - '0';

        if (!(i & 1)) {
            blocks.push_back({id, size});
        } else {
            blocks.push_back({-1, size});
        }

        if ((i & 1) == 0) {
            id++;
        }
    }

    int empty = 1;
    int last = blocks.size() - 1;

    while (last > 0 && empty < last) {
        if (blocks[empty].second >= blocks[last].second) {
            blocks[empty].second -= blocks[last].second;

            blocks.insert(blocks.begin() + empty, blocks[last]);

            // indexes moved after insertion
            empty++;
            last++;

            blocks[last].first = -1;

            while (blocks[last].first == -1 && last > 0) {
                last--;
            }

            // current block changed, go back to initial empty slot to test
            empty = find_if(blocks.begin(), blocks.end(), [](pair<int, int> v) { return v.first == -1 && v.second != 0; }) - blocks.begin();
        } else {
            empty++;
            while ((blocks[empty].first != -1 || blocks[empty].second == 0) && empty < last) {
                empty++;
            }

            // current block won't be moved
            if (empty >= last) {
                last--;
                while (blocks[last].first == -1 && last > 0) {
                    last--;
                }

                // current block changed, go back to initial empty slot to test
                empty = find_if(blocks.begin(), blocks.end(), [](pair<int, int> v) { return v.first == -1 && v.second != 0; }) - blocks.begin();
            }
        }
    }

    uint64_t checksum = 0;

    int chk_idx = 0;
    for (auto& p : blocks) {
        if (p.first == -1) {
            chk_idx += p.second;
            continue;
        }

        for (int i = 0; i < p.second; i++) {
            checksum += chk_idx * p.first;
            chk_idx++;
        }
    }

    cout << checksum << endl;

    return checksum;
}

void test() {
    string example = R"(2333133121414131402)";

    assert(part1(Input::from_raw(example)) == 1928);
    assert(part2(Input::from_raw(example)) == 2858);
}
