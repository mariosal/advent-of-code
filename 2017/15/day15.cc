#include <cstdio>

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
  for (int i = 0; i < 40000000; ++i) {
    value_a = (value_a * 16807) % 2147483647;
    value_b = (value_b * 48271) % 2147483647;

    bool* bits_a = Binary(value_a);
    bool* bits_b = Binary(value_b);

    matches += Match(bits_a, bits_b);

    delete[] bits_a;
    delete[] bits_b;
  }
  printf("%d\n", matches);

  return 0;
}
