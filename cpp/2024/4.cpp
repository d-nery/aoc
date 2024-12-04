#include <bits/stdc++.h>

#include "../utils/utils.h"

using namespace std;

int part1(Input input) {
    int xmas = 0;

    auto grid = input.lines();

    int mi = grid.size();
    int mj = grid[0].length();

    for (int i = 0; i < mi; i++) {
        for (int j = 0; j < mj; j++) {
            if (grid[i][j] != 'X') {
                continue;
            }

            // These should be loops xD
            // N
            if (i >= 3) {
                xmas += grid[i - 1][j] == 'M' && grid[i - 2][j] == 'A' && grid[i - 3][j] == 'S';
            }

            // NE
            if (i >= 3 && j < mj - 3) {
                xmas += grid[i - 1][j + 1] == 'M' && grid[i - 2][j + 2] == 'A' && grid[i - 3][j + 3] == 'S';
            }

            // E
            if (j < mj - 3) {
                xmas += grid[i][j + 1] == 'M' && grid[i][j + 2] == 'A' && grid[i][j + 3] == 'S';
            }

            // SE
            if (i < mi - 3 && j < mj - 3) {
                xmas += grid[i + 1][j + 1] == 'M' && grid[i + 2][j + 2] == 'A' && grid[i + 3][j + 3] == 'S';
            }

            // S
            if (i < mi - 3) {
                xmas += grid[i + 1][j] == 'M' && grid[i + 2][j] == 'A' && grid[i + 3][j] == 'S';
            }

            // SW
            if (i < mi - 3 && j >= 3) {
                xmas += grid[i + 1][j - 1] == 'M' && grid[i + 2][j - 2] == 'A' && grid[i + 3][j - 3] == 'S';
            }

            // W
            if (j >= 3) {
                xmas += grid[i][j - 1] == 'M' && grid[i][j - 2] == 'A' && grid[i][j - 3] == 'S';
            }

            // NW
            if (i >= 3 && j >= 3) {
                xmas += grid[i - 1][j - 1] == 'M' && grid[i - 2][j - 2] == 'A' && grid[i - 3][j - 3] == 'S';
            }
        }
    }

    return xmas;
}

int part2(Input input) {
    int x_mas = 0;

    auto grid = input.lines();

    int mi = grid.size();
    int mj = grid[0].length();

    for (int i = 1; i < mi - 1; i++) {
        for (int j = 1; j < mj - 1; j++) {
            if (grid[i][j] != 'A') {
                continue;
            }

            bool diag1 = (grid[i - 1][j - 1] == 'M' && grid[i + 1][j + 1] == 'S') || (grid[i - 1][j - 1] == 'S' && grid[i + 1][j + 1] == 'M');
            bool diag2 = (grid[i + 1][j - 1] == 'M' && grid[i - 1][j + 1] == 'S') || (grid[i + 1][j - 1] == 'S' && grid[i - 1][j + 1] == 'M');

            x_mas += diag1 && diag2;
        }
    }

    return x_mas;
}

void test() {
    string example = R"(MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX)";

    assert(part1(Input::from_raw(example)) == 18);
    assert(part2(Input::from_raw(example)) == 9);
}
