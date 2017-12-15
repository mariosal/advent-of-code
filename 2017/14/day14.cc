#include <cstdio>
#include <set>
#include <string>
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

static char* Hash(const char* in) {
  const size_t N = 256;
  int a[N];
  for (size_t i = 0; i < N; ++i) {
    a[i] = i;
  }

  vector<size_t> lens;
  for (size_t i = 0; in[i]; ++i) {
    lens.push_back(in[i]);
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

  char* out = new char[33];
  for (size_t j = 0; j < 16; ++j) {
    int acc = 0;
    for (size_t k = 0; k < 16; ++k) {
      acc ^= a[16 * j + k];
    }
    sprintf(out + 2 * j, "%02x", acc);
  }
  out[32] = '\0';
  return out;
}

static int CountOnes(const char* s, bool* row) {
  int ret = 0;
  size_t j = 0;
  for (size_t i = 0; s[i]; ++i) {
    int n = 0;
    if ('0' <= s[i] && s[i] <= '9') {
      n = s[i] - '0';
    } else if ('a' <= s[i] && s[i] <= 'f') {
      n = s[i] - 'a' + 10;
    }
    row[j] = row[j + 1] = row[j + 2] = row[j + 3] = 0;
    size_t k = 0;
    while (n > 0) {
      ret += n % 2;
      row[j + 3 - k] = n % 2;
      n /= 2;
      ++k;
    }
    j += 4;
  }

  return ret;
}

static int FloodFill(const bool* const* grid, int i, int j) {
  if (i < 0 || 128 <= i || j < 0 || 128 <= j || !grid[i][j]) {
    return 0;
  }
  static set< pair<int, int> > visited;
  if (!visited.insert(make_pair(i, j)).second) {
    return 0;
  }

  int dx[4] = { 0, 1, 0, -1 };
  int dy[4] = { -1, 0, 1, 0 };
  for (int k = 0; k < 4; ++k) {
    FloodFill(grid, i + dx[k], j + dy[k]);
  }
  return 1;
}

int main() {
  string in;
  while (true) {
    char c;
    if (scanf("%c", &c) == EOF) {
      break;
    }
    if (c != '\n') {
      in += c;
    }
  }
  in += '-';

  int ones = 0;
  bool** grid = new bool*[128];
  for (size_t i = 0; i < 128; ++i) {
    grid[i] = new bool[128];

    char suffix[4];
    sprintf(suffix, "%zu", i);
    char* hash = Hash((in + suffix).c_str());
    ones += CountOnes(hash, grid[i]);
    delete[] hash;
  }

  printf("%d\n", ones);

  int regions = 0;
  for (size_t i = 0; i < 128; ++i) {
    for (size_t j = 0; j < 128; ++j) {
      regions += FloodFill(grid, i, j);
    }
  }
  printf("%d\n", regions);

  for (size_t i = 0; i < 128; ++i) {
    delete[] grid[i];
  }
  delete[] grid;

  return 0;
}
