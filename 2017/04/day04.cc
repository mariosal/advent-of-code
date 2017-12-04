#include <cstdio>
#include <cstring>
#include <algorithm>
#include <set>
#include <string>

int main() {
  int valid = 0;
  char buf[256];
  std::set<std::string> memo;
  while (true) {
    if (scanf("%[^\n]", buf) == EOF) {
      break;
    }
    getchar();

    ++valid;
    char* p = strtok(buf, " ");
    while (p != nullptr) {
#if defined(PART) && PART == 2
      std::sort(p, p + strlen(p));
#endif
      if (!memo.insert(p).second) {
        --valid;
        break;
      }
      p = strtok(NULL, " ");
    }
    memo.clear();
  }
  printf("%d\n", valid);
}
