#include <bits/stdc++.h>
#include <ranges>
#include <z3++.h>

#include "../utils/utils.h"

using namespace std;

uint64_t movements(array<pair<int64_t, int64_t>, 3> const& params) {

    auto [A, B, P] = params;
    auto [Ax, Ay] = A;
    auto [Bx, By] = B;
    auto [Px, Py] = P;

    // (E1) => Px = a * Ax + b * Bx
    // (E2) => Py = a * Ay + b * By
    // a, b <= 100 for P1

    // (E3) => Ay * (E1) => Ay * a * Ax + Ay * b * Bx = Ay * Px
    // (E4) => Ax * (E2) => Ax * a * Ay + Ax * b * By = Ax * Py
    // (E5) => (E3 - E4) => 0 + b(Ay*Bx - Ax*By) = Ay*Px - Ax*Py

    int64_t b = (Ay * Px - Ax * Py) / (Ay * Bx - Ax * By); // from E5
    int64_t a = (Px - b * Bx) / (Ax);                      // from E1

    if (a * Ax + b * Bx == Px && a * Ay + b * By == Py) {
        return 3 * a + b;
    }

    return 0;
}

uint64_t part1(Input input) {
    auto lines = input.lines();

    // A, B, Prize
    array<pair<int64_t, int64_t>, 3> values = {};

    uint64_t tokens = 0;

    for (auto& line : lines) {
        if (line.starts_with("Button A")) {
            sscanf(line.c_str(), "Button A: X%ld, Y%ld", &values[0].first, &values[0].second);
        } else if (line.starts_with("Button B")) {
            sscanf(line.c_str(), "Button B: X%ld, Y%ld", &values[1].first, &values[1].second);
        } else if (line.starts_with("Prize")) {
            sscanf(line.c_str(), "Prize: X=%ld, Y=%ld", &values[2].first, &values[2].second);
        }

        if (line.empty()) {
            tokens += movements(values);
        }
    }

    // Calculate last one since there's no empty line in the end
    tokens += movements(values);

    return tokens;
}

uint64_t part2(Input input) {
    auto lines = input.lines();

    // A, B, Prize
    array<pair<int64_t, int64_t>, 3> values = {};

    uint64_t tokens = 0;

    for (auto& line : lines) {
        if (line.starts_with("Button A")) {
            sscanf(line.c_str(), "Button A: X%ld, Y%ld", &values[0].first, &values[0].second);
        } else if (line.starts_with("Button B")) {
            sscanf(line.c_str(), "Button B: X%ld, Y%ld", &values[1].first, &values[1].second);
        } else if (line.starts_with("Prize")) {
            sscanf(line.c_str(), "Prize: X=%ld, Y=%ld", &values[2].first, &values[2].second);
            values[2].first += 10000000000000;
            values[2].second += 10000000000000;
        }

        if (line.empty()) {
            tokens += movements(values);
        }
    }

    // Calculate last one since there's no empty line in the end
    tokens += movements(values);

    return tokens;
}

void test() {
    string example = R"(Button A: X+94, Y+34
Button B: X+22, Y+67
Prize: X=8400, Y=5400

Button A: X+26, Y+66
Button B: X+67, Y+21
Prize: X=12748, Y=12176

Button A: X+17, Y+86
Button B: X+84, Y+37
Prize: X=7870, Y=6450

Button A: X+69, Y+23
Button B: X+27, Y+71
Prize: X=18641, Y=10279)";

    assert(part1(Input::from_raw(example)) == 480);
    assert(part2(Input::from_raw(example)) == 875318608908);
}
