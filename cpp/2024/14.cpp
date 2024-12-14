#include <bits/stdc++.h>

#include "../utils/utils.h"

using namespace std;

struct Robot {
    int64_t px, py, vx, vy;
};

static int max_x = 101;
static int max_y = 103;

uint64_t part1(Input input) {
    array<uint64_t, 4> quads = {0, 0, 0, 0};

    for (auto& line : input.lines()) {
        Robot r;
        sscanf(line.c_str(), "p=%ld,%ld v=%ld,%ld", &r.px, &r.py, &r.vx, &r.vy);

        // 100 s
        if (r.vx < 0) {
            r.vx += max_x;
        }

        if (r.vy < 0) {
            r.vy += max_y;
        }

        r.px = (r.px + 100 * r.vx) % max_x;
        r.py = (r.py + 100 * r.vy) % max_y;

        if (r.px < max_x / 2 && r.py < max_y / 2) {
            quads[0]++;
        } else if (r.px > max_x / 2 && r.py < max_y / 2) {
            quads[1]++;
        } else if (r.px < max_x / 2 && r.py > max_y / 2) {
            quads[2]++;
        } else if (r.px > max_x / 2 && r.py > max_y / 2) {
            quads[3]++;
        }
    }

    return quads[0] * quads[1] * quads[2] * quads[3];
}

uint64_t part2(Input input) {
    vector<Robot> robots;

    for (auto& line : input.lines()) {
        Robot r;
        sscanf(line.c_str(), "p=%ld,%ld v=%ld,%ld", &r.px, &r.py, &r.vx, &r.vy);

        // 100 s
        if (r.vx < 0) {
            r.vx += max_x;
        }

        if (r.vy < 0) {
            r.vy += max_y;
        }

        robots.push_back(r);
    }

    // From manual inspection it's a bit after this xD
    int cnt = 7000;
    for (auto& r : robots) {
        r.px = (r.px + cnt * r.vx) % max_x;
        r.py = (r.py + cnt * r.vy) % max_y;
    }

    for (;;) {
        printf("\e[1;1H\e[2J");
        for (auto& r : robots) {
            r.px = (r.px + r.vx) % max_x;
            r.py = (r.py + r.vy) % max_y;
        }

        for (int y = 0; y < max_y; y++) {
            for (int x = 0; x < max_x; x++) {
                bool found = false;
                for (auto& r : robots) {
                    if (r.px == x && r.py == y) {
                        found = true;
                        break;
                    }
                }

                found ? printf("\033[48;5;76m \033[0m") : printf(" ");
            }
            cout << endl;
        }

        cout << ++cnt << endl;

        getchar();
    }

    return 0;
}

void test() {
    max_x = 11;
    max_y = 7;

    string example = R"(p=0,4 v=3,-3
p=6,3 v=-1,-3
p=10,3 v=-1,2
p=2,0 v=2,-1
p=0,0 v=1,3
p=3,0 v=-2,-2
p=7,6 v=-1,-3
p=3,0 v=-1,-2
p=9,3 v=2,3
p=7,3 v=-1,2
p=2,4 v=2,-3
p=9,5 v=-3,-3)";

    assert(part1(Input::from_raw(example)) == 12);
    assert(part2(Input::from_raw(example)) == 0);
}
