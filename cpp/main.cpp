#include <chrono>
#include <fstream>
#include <iostream>
#include <sstream>
#include <string>

#include "utils/utils.h"

using namespace std;

int part1(Input input);
int part2(Input input);
void test();

int main(int argc, char* argv[]) {
    Input inp(argv[2]);

    auto start = chrono::steady_clock::now();

    cout << "Done! [";
    if (argv[1][0] == '1') {
        cout << part1(inp);
    } else if (argv[1][0] == '2') {
        cout << part2(inp);
    } else {
        test();
    }

    auto runtime = chrono::steady_clock::now() - start;
    if (auto runtime_ms = std::chrono::duration_cast<chrono::milliseconds>(runtime).count(); runtime_ms != 0) {
        cout << "] in " << runtime_ms << "ms" << endl;
    } else {
        auto runtime_us = std::chrono::duration_cast<chrono::microseconds>(runtime).count();
        cout << "] in " << runtime_us << "us" << endl;
    }
}
