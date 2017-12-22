#include <cstdio>
#include <map>
#include <vector>

using namespace std;

struct Point {
  int x;
  int y;

  bool operator <(const Point& o) const {
    if (x == o.x) {
      return y < o.y;
    }
    return x < o.x;
  }
};

static int Walk(map<Point, int>* grid, Point s, int n) {
  int ret = 0;
  int dx[4] = {  0, 1, 0, -1 };
  int dy[4] = { -1, 0, 1,  0 };
  int d = 0;
  for (int i = 0; i < n; ++i) {
    if ((*grid)[s] == 0) {
      d = ((d - 1) % 4 + 4) % 4;  // In C++ -1 % 4 = -3, so I fix this :)
    } else if ((*grid)[s] == 1) {
      ++ret;
    } else if ((*grid)[s] == 2) {
      d = (d + 1) % 4;
    } else {
      d = ((d - 2) % 4 + 4) % 4;  // In C++ -1 % 4 = -3, so I fix this :)
    }
    (*grid)[s] = ((*grid)[s] + 1) % 4;
    s.x += dx[d];
    s.y += dy[d];
  }
  return ret;
}

int main() {
  vector< vector<bool> > in;
  while (true) {
    vector<bool> row;
    while (true) {
      int c = getchar();
      if (c == '\n' || c == EOF) {
        break;
      }
      row.push_back(c == '#');
    }
    if (feof(stdin)) {
      break;
    }
    in.push_back(row);
  }

  map<Point, int> grid;
  for (size_t i = 0; i < in.size(); ++i) {
    for (size_t j = 0; j < in[i].size(); ++j) {
      Point p = {
        static_cast<int>(j) - static_cast<int>(in.size()) / 2,
        static_cast<int>(i) - static_cast<int>(in.size()) / 2
      };
      grid[p] = in[i][j] ? 2 : 0;
    }
  }

  printf("%d\n", Walk(&grid, { 0, 0 }, 10000000));

  return 0;
}
