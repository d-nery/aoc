#pragma once

#include <fstream>
#include <sstream>
#include <string>
#include <vector>

#include "./grid.h"

class Input {
public:
    Input(std::string path);

    static Input from_raw(std::string raw);
    std::string raw();
    std::vector<std::string> lines();

    Grid<char> grid() {
        std::vector<std::vector<char>> chars;
        for (auto& l : lines()) {
            chars.push_back(std::vector(l.begin(), l.end()));
        }

        return Grid(chars);
    }

private:
    Input() {}

    std::string path;
    std::string _raw;
};
