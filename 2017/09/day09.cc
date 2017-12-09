#include <cstdio>

int main() {
  int local_score = 0;
  int total_score = 0;
  int garbage_chars = 0;
  bool garbage = false;
  bool ignore = false;
  while (true) {
    char ch;
    if (scanf("%c", &ch) == EOF) {
      break;
    }
    if (ignore) {
      ignore = false;
      continue;
    }

    if (ch == '!') {
      ignore = true;
    }

    if (!garbage) {
      switch (ch) {
        case '{': {
          ++local_score;
          total_score += local_score;
          break;
        }
        case '}': {
          --local_score;
          break;
        }
        case '<': {
          garbage = true;
          break;
        }
      }
    } else if (ch == '>') {
      garbage = false;
    } else if (ch != '!') {
      ++garbage_chars;
    }
  }
  printf("%d %d\n", total_score, garbage_chars);

  return 0;
}
