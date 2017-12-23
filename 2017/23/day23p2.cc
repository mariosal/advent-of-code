#include <cstdio>

int main() {
  int in;
  scanf("%*s%*s%d", &in);

  int h = 0;
  for (int b = in * 100 + 100000; b <= in * 100 + 117000; b += 17) {
    // Check if b is prime
    for (int d = 2; d * d < b; ++d) {
      if (b % d == 0) {
        ++h;
        break;
      }
    }
  }

  printf("%d\n", h);

  return 0;
}
