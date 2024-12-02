#include <bits/stdc++.h>

#include "utils.h"

using namespace std;

Input::Input(std::string path) : path(path) {}

Input Input::from_raw(std::string raw) {
    Input i;
    i._raw = raw;
    return i;
}

std::string Input::raw() {
    if (!_raw.empty()) {
        return _raw;
    }

    std::ifstream t(path);
    std::stringstream buffer;
    buffer << t.rdbuf();
    _raw = buffer.str();
    return _raw;
}

std::vector<std::string> Input::lines() {
    std::basic_istream<char>* s;

    if (path.empty()) {
        s = new std::basic_istringstream<char>(std::basic_string<char>(_raw.c_str()));
    } else {
        s = new std::basic_ifstream<char>(path);
    }

    std::string line;
    std::vector<std::string> r;

    while (getline(*s, line)) {
        r.push_back(line);
    }

    return r;
}
