#include <cstdio>
#include <vector>

int main() {
  std::vector<int> a;
  while (true) {
    int n;
    if (scanf("%d", &n) == EOF) {
      break;
    }
    a.push_back(n);
  }

  int steps = 0;
  int i = a[0];
  while (0 <= i && i < a.size()) {
    int tmp = a[i];
#if !defined(PART) || PART == 1
    ++a[i];
#else
    if (a[i] >= 3) {
      --a[i];
    } else {
      ++a[i];
    }
#endif
    i += tmp;
    ++steps;
  }
  printf("%d\n", steps);

  return 0;
}
