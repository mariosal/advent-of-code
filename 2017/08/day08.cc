#include <climits>
#include <cstdio>
#include <cstring>
#include <map>
#include <string>

using namespace std;

static int Max(int a, int b) {
  return (a > b) ? a : b;
}

int main() {
  int max_local = INT_MIN;
  map<string, int> values;
  while (true) {
    char lreg[16];
    if (scanf("%s", lreg) == EOF) {
      break;
    }

    char instr[16], rreg[16], cond[3];
    int lval, rval;
    scanf("%s%d%*s%s%s%d", instr, &lval, rreg, cond, &rval);

    if (values.find(lreg) == values.end()) {
      values[lreg] = 0;
    }
    if (values.find(rreg) == values.end()) {
      values[rreg] = 0;
    }

    lval *= !strcmp(instr, "inc") * 1 + !strcmp(instr, "dec") * -1;

    if ((!strcmp(cond, "==") && values[rreg] == rval) ||
        (!strcmp(cond, "!=") && values[rreg] != rval) ||
        (!strcmp(cond, "<=") && values[rreg] <= rval) ||
        (!strcmp(cond, ">=") && values[rreg] >= rval) ||
        (!strcmp(cond, "<") && values[rreg] < rval) ||
        (!strcmp(cond, ">") && values[rreg] > rval)) {
      values[lreg] += lval;
      max_local = Max(max_local, values[lreg]);
    }
  }

  int max = INT_MIN;
  for (auto it = values.cbegin(); it != values.cend(); ++it) {
    max = Max(max, it->second);
  }
  printf("%d %d\n", max, max_local);

  return 0;
}
