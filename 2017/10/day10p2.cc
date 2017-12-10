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

  vector<size_t> lens;
  while (true) {
    char len;
    if (scanf("%c", &len) == EOF) {
      break;
    }
    if (len != '\n') {
      lens.push_back(len);
    }
  }

  int suffix[5] = { 17, 31, 73, 47, 23 };
  lens.insert(lens.end(), suffix, suffix + 5);

  size_t i = 0;
  size_t skip = 0;
  for (int k = 0; k < 64; ++k) {
    for (size_t j = 0; j < lens.size(); ++j) {
      Reverse(a, N, i, lens[j]);
      i += (lens[j] + skip) % N;
      ++skip;
    }
  }

  for (size_t j = 0; j < 16; ++j) {
    int acc = 0;
    for (size_t k = 0; k < 16; ++k) {
      acc ^= a[16 * j + k];
    }
    printf("%02x", acc);
  }
  printf("\n");

  return 0;
}
