#include <cstdio>
#include <queue>

using namespace std;

static bool* Binary(long long n) {
  bool* bits = new bool[32];
  size_t i = 0;
  while (n > 0) {
    bits[31 - i++] = n % 2;
    n /= 2;
  }

  for (size_t j = 0; j <= 31 - i; ++j) {
    bits[j] = false;
  }

  return bits;
}

static bool Match(const bool* a, const bool* b) {
  for (size_t i = 16; i < 32; ++i) {
    if (a[i] != b[i]) {
      return false;
    }
  }
  return true;
}

int main() {
  long long value_a, value_b;
  scanf("%*s%*s%*s%*s%lld%*s%*s%*s%*s%lld", &value_a, &value_b);

  int matches = 0;
  queue<long long> q_a, q_b;
  for (int i = 0; i < 5000000;) {
    value_a = (value_a * 16807) % 2147483647;
    value_b = (value_b * 48271) % 2147483647;

    if (value_a % 4 == 0) {
      q_a.push(value_a);
    }
    if (value_b % 8 == 0) {
      q_b.push(value_b);
    }

    if (!q_a.empty() && !q_b.empty()) {
      bool* bits_a = Binary(q_a.front());
      bool* bits_b = Binary(q_b.front());
      q_a.pop();
      q_b.pop();

      matches += Match(bits_a, bits_b);

      delete[] bits_a;
      delete[] bits_b;
      ++i;
    }
  }
  printf("%d\n", matches);

  return 0;
}
