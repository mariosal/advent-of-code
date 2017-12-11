#include <cstdio>
#include <cstdlib>
#include <algorithm>
#include <map>
#include <string>

using namespace std;

struct Hex {
  int x;
  int y;

  Hex() : x(0), y(0) {
  }

  Hex(int x_, int y_) : x(x_), y(y_) {
  }

  int Dist(const Hex& a) {
    return (abs(x - a.x) + abs(x + y - a.x - a.y) + abs(y - a.y)) / 2;
  }

  void Print() {
    printf("%d %d\n", x, y);
  }

  Hex& operator =(const Hex& a) {
    if (this == &a) {
      return *this;
    }
    x = a.x;
    y = a.y;
    return *this;
  }

  Hex& operator +=(const Hex& a) {
    x += a.x;
    y += a.y;
    return *this;
  }
};

int main() {
  map<string, Hex> d;
  d["nw"] = Hex(1, -1);
  d["n"] = Hex(1, 0);
  d["ne"] = Hex(0, 1);
  d["se"] = Hex(-1, 1);
  d["s"] = Hex(-1, 0);
  d["sw"] = Hex(0, -1);

  Hex h(0, 0);
  int max_dist = 0;
  while (true) {
    char buf[3];
    if (scanf("%[^,\n]", buf) == EOF) {
      break;
    }
    getchar();

    h += d[buf];
    max_dist = max(max_dist, h.Dist(Hex(0, 0)));
  }

  h.Print();
  printf("%d %d\n", h.Dist(Hex(0, 0)), max_dist);

  return 0;
}
