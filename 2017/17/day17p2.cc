#include <cstdio>
#include <list>

using namespace std;

int main() {
  size_t steps;
  scanf("%zu", &steps);

  list<int> buf(1, 0);
  auto it = buf.begin();
  for (int j = 1; j <= 50000000; ++j) {
    for (size_t k = 0; k < steps; ++k) {
      ++it;
      if (it == buf.end()) {
        it = buf.begin();
      }
    }
    if (it == buf.begin()) {
    }
    buf.insert(it, j);
  }
  for (it = buf.begin(); it != buf.end(); ++it) {
    if (*it == 0) {
      ++it;
      if (it == buf.end()) {
        it = buf.begin();
      }
      printf("%d\n", *it);
      break;
    }
  }

  return 0;
}
