#pragma once

#include <format>
#include <ostream>
#include <string>

using std::vector;

struct Point {
    int x, y;

    Point operator+(const Point& other) const { return Point{x + other.x, y + other.y}; }
    Point operator-(const Point& other) { return Point{x - other.x, y - other.y}; }
    auto operator<=>(const Point&) const = default;
    std::string to_string() const { return std::format("({},{})", x, y); }

    friend std::ostream& operator<<(std::ostream& o, const Point& p) { return o << p.to_string(); };
};

template <typename T>
class Grid {
public:
    class Iterator {
        int x = 0, y = 0;
        vector<vector<T>>* data;

    public:
        Iterator(vector<vector<T>>* data, bool end = false) : data(data) {
            if (end) {
                x = data->size();
                y = data->at(0).size();
            }
        }

        std::pair<T&, Point> operator*() const { return {data->at(x)[y], {x, y}}; }
        std::pair<T*, Point> operator->() const { return {&data->at(x)[y], {x, y}}; }

        Iterator& operator++() {
            if (++x == (int)data->size()) {
                x = 0;
                y++;
            }

            if (y == (int)data->at(0).size()) {
                x = data->size();
            }

            return *this;
        }

        Iterator operator++(int) {
            Iterator tmp = *this;
            ++(*this);
            return tmp;
        }

        friend bool operator==(const Iterator& a, const Iterator& b) { return a.x == b.x && a.y == b.y; };
        friend bool operator!=(const Iterator& a, const Iterator& b) { return !(a == b); };
    };

    constexpr inline bool is_inside(Point const& point) {
        int max_x = inner.size();
        int max_y = inner[0].size();

        return point.x >= 0 && point.x < max_x && point.y >= 0 && point.y < max_y;
    }

    Grid(vector<vector<T>> data) : inner(data) {}

    std::pair<int, int> size() const { return {inner.size(), inner[0].size()}; }

    T operator[](const Point idx) { return inner[idx.x][idx.y]; }

    void dump() {}

    Iterator begin() { return Iterator(&inner); }
    Iterator end() { return Iterator(&inner, true); }

private:
    vector<vector<T>> inner;
};

constexpr std::array<Point, 4> directions = {Point(-1, 0), Point(0, 1), Point(1, 0), Point(0, -1)};
