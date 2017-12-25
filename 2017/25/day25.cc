#include <cstdio>
#include <cstring>
#include <map>

using namespace std;

struct Move {
  bool val;
  bool dir; // true = +1, false = -1
  char st;
};

static void Read(char* init_st, int* steps,
                 map< char, map<bool, Move> >* st) {
  scanf("%*s%*s%*s %c.%*s%*s%*s%*s%*s%d%*s", init_st, steps);

  map<bool, Move> moves;
  while (true) {
    char cur_st;
    if (scanf("%*s%*s %c:", &cur_st) == EOF) {
      break;
    }

    for (int i = 0; i < 2; ++i) {
      int cur_val;
      scanf("%*s%*s%*s%*s%*s%d:", &cur_val);

      Move tmp;
      int next_val;
      scanf("%*s%*s%*s%*s%d.", &next_val);
      tmp.val = next_val;

      char buf[6];
      scanf("%*s%*s%*s%*s%*s%*s %[^.].", buf);
      tmp.dir = !strcmp(buf, "right");

      char next_st;
      scanf("%*s%*s%*s%*s %c.", &next_st);
      tmp.st = next_st;

      moves[cur_val] = tmp;
    }
    (*st)[cur_st] = moves;
  }
}

int main() {
  map<int, bool> tape;

  char cur_st;
  int steps;
  map< char, map<bool, Move> > st;
  Read(&cur_st, &steps, &st);

  int cursor = 0;
  for (int i = 0; i < steps; ++i) {
    Move tmp = st[cur_st][tape[cursor]];

    tape[cursor] = tmp.val;
    cursor += !tmp.dir * -1 + tmp.dir * 1;
    cur_st = tmp.st;
  }

  int count_true = 0;
  for (map<int, bool>::const_iterator it = tape.cbegin(); it != tape.cend(); ++it) {
    if (it->second) {
      ++count_true;
    }
  }
  printf("%d\n", count_true);

  return 0;
}
