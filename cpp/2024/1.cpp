#include <bits/stdc++.h>
#include <ranges>

#include "../utils/utils.h"

using namespace std;

int part1(Input input) {
    vector<int> v1;
    vector<int> v2;

    for (auto& line : input.lines()) {
        stringstream s(line);

        int n1, n2;
        s >> n1 >> n2;

        v1.push_back(n1);
        v2.push_back(n2);
    }

    sort(v1.begin(), v1.end());
    sort(v2.begin(), v2.end());

    return ranges::fold_left(ranges::views::zip_transform([](int& n1, int& n2) { return abs(n1 - n2); }, v1, v2), 0, plus<int>{});
}

int part2(Input input) {
    vector<int> v1;
    map<int, int> v2;

    for (auto& line : input.lines()) {
        stringstream s(line);

        int n1, n2;
        s >> n1 >> n2;

        v1.push_back(n1);
        v2.contains(n2) ? v2[n2]++ : v2[n2] = 1;
    }

    int s = 0;
    for (size_t i = 0; i < v1.size(); i++) {
        if (v2.contains(v1[i])) {
            s += v1[i] * v2[v1[i]];
        }
    }

    return s;
}

void test() {
    string example = R"(3   4
4   3
2   5
1   3
3   9
3   3)";

    assert(part1(Input::from_raw(example)) == 11);
    assert(part2(Input::from_raw(example)) == 31);
}
