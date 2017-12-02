#include <cctype>
#include <climits>
#include <cstdio>

static int Min(int a, int b) {
  if (a > b) {
    return b;
  }
  return a;
}

static int Max(int a, int b) {
  if (a < b) {
    return b;
  }
  return a;
}

static int ReadInt(int* n) {
  *n = 0;

  while (true) {
    char ch;
    if (scanf("%c", &ch) == EOF) {
      return -1;
    }
    if (ch == '\n') {
      return 1;
    }
    if (isspace(ch)) {
      return 0;
    }

    if ('0' <= ch && ch <= '9') {
      *n = *n * 10 + ch - '0';
    }
  }
}

int main() {
  int checksum = 0;
  int min = INT_MAX;
  int max = INT_MIN;
  while (true) {
    int n;
    int e = ReadInt(&n);

    if (e == -1) {
      break;
    }

    min = Min(min, n);
    max = Max(max, n);

    if (e == 1) {
      checksum += max - min;
      min = INT_MAX;
      max = INT_MIN;
    }
  }

  printf("%d\n", checksum);

  return 0;
}
