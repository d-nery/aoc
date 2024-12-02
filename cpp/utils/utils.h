#pragma once

#include <fstream>
#include <sstream>
#include <string>
#include <vector>

class Input {
public:
    Input(std::string path);

    static Input from_raw(std::string raw);
    std::string raw();
    std::vector<std::string> lines();

private:
    Input() {}

    std::string path;
    std::string _raw;
};
