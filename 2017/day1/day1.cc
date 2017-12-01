#include <cstdio>
#include <vector>

int main() {
  std::vector<int> nums;

  while (true) {
    char ch;
    if (scanf("%c", &ch) == EOF) {
      break;
    }
    if ('0' <= ch && ch <= '9') {
      nums.push_back(ch - '0');
    }
  }

  int sum = 0;
#if !defined(PART) || PART == 1
  size_t step = 1;
#else
  size_t step = nums.size() / 2;
#endif
  for (size_t i = 0; i < nums.size(); ++i) {
    if (nums[i] == nums[(i + step) % nums.size()]) {
      sum += nums[i];
    }
  }
  std::printf("%d\n", sum);

  return 0;
}
