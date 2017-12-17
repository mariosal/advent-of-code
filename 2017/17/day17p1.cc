#include <cstdio>
#include <vector>

using namespace std;

int main() {
  size_t steps;
  scanf("%zu", &steps);

  vector<int> buf(1, 0);
  size_t i = 0;
  for (int j = 1; j <= 2017; ++j) {
    if (i == buf.size() - 1) {
      i = (i + steps) % (buf.size() + 1);
    } else {
      i = (i + steps + 1) % buf.size();
    }
    buf.insert(buf.begin() + i, j);
  }
  printf("%d\n", buf[(i + 1) % buf.size()]);

  return 0;
}
