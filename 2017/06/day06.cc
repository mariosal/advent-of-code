#include <cstdio>
#include <map>
#include <vector>

static size_t MaxIndex(const std::vector<int>& a) {
  size_t index = 0;
  int max = a[0];
  for (size_t i = 1; i < a.size(); ++i) {
    if (max < a[i]) {
      max = a[i];
      index = i;
    }
  }
  return index;
}

static int Redistribute(std::vector<int> a) {
  int cycles = 0;
  std::map<std::vector<int>, int> memo;
  while (memo.find(a) == memo.end()) {
    memo[a] = cycles++;
    size_t i = MaxIndex(a);
    int tmp = a[i];
    a[i] = 0;
    while (tmp > 0) {
      i = (i + 1) % a.size();
      ++a[i];
      --tmp;
    }
  }
#if !defined(PART) || PART == 1
  return cycles;
#else
  return cycles - memo[a];
#endif
}

int main() {
  std::vector<int> a;
  while (true) {
    int n;
    if (scanf("%d", &n) == EOF) {
      break;
    }
    a.push_back(n);
  }

  printf("%d\n", Redistribute(a));

  return 0;
}
