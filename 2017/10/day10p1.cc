#include <cstdio>
#include <vector>

using namespace std;

static void Swap(int* a, int* b) {
  int tmp = *a;
  *a = *b;
  *b = tmp;
}

static void Reverse(int* a, size_t n, size_t i, size_t len) {
  for (size_t j = 0; 2 * j < len; ++j) {
    Swap(a + (i + j) % n, a + (i + len - j - 1) % n);
  }
}

int main() {
  const size_t N = 256;
  int a[N];
  for (size_t i = 0; i < N; ++i) {
    a[i] = i;
  }

  vector<int> lens;
  while (true) {
    size_t len;
    if (scanf("%zu,", &len) == EOF) {
      break;
    }
    if (len <= N) {
      lens.push_back(len);
    }
  }

  size_t i = 0;
  size_t skip = 0;
  for (size_t j = 0; j < lens.size(); ++j) {
    Reverse(a, N, i, lens[j]);
    i += (lens[j] + skip) % N;
    ++skip;
  }

  printf("%d\n", a[0] * a[1]);

  return 0;
}
