#include <cmath>
#include <cstdio>
#include <map>

using namespace std;

int main() {
  map<int, int> firewall;

  while (true) {
    int i, r;
    if (scanf("%d: %d", &i, &r) == EOF) {
      break;
    }
    firewall[i] = r;
  }

  int delay = 0;
  while (true) {
    bool caught = false;
    for (int i = 0; i <= firewall.crbegin()->first; ++i) {
      auto it = firewall.find(i);
      if (it != firewall.end()) {
        int range = it->second;
        int col;
        if (i + delay == 0) {
          col = 1;
        }else {
          col = static_cast<int>(ceil((i + delay) / (range - 1.0)));
        }
        int pos;

        // Direction: +
        if (col % 2 == 1) {
          pos = (i + delay - 1 * (i + delay != 0)) % (range - 1) + 1 * ((i + delay) != 0);
        } else { // Direction: -
          pos = range - ((i + delay - 1) % (range - 1) + 1) - 1;
        }
        //printf("%d: %d\n", i, pos);
        if (pos == 0) {
          caught = true;
          break;
        }
      }
    }

    if (!caught) {
      break;
    }

    ++delay;
  }
  printf("%d\n", delay);

  return 0;
}
