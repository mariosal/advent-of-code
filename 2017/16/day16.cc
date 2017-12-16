#include <cstdio>
#include <set>
#include <string>
#include <vector>

using namespace std;

static void Spin(vector<char>* prog, size_t x) {
  vector<char> tmp(x);
  for (int i = x - 1; i >= 0; --i) {
    tmp[i] = prog->back();
    prog->pop_back();
  }
  prog->insert(prog->begin(), tmp.begin(), tmp.end());
}

static void Exchange(vector<char>* prog, size_t a, size_t b) {
  char tmp = (*prog)[a];
  (*prog)[a] = (*prog)[b];
  (*prog)[b] = tmp;
}

static void Partner(vector<char>* prog, char a, char b) {
  size_t a_pos, b_pos;
  for (size_t i = 0; i < prog->size(); ++i) {
    if ((*prog)[i] == a) {
      a_pos = i;
    } else if ((*prog)[i] == b) {
      b_pos = i;
    }
  }
  Exchange(prog, a_pos, b_pos);
}

static void Move(vector<char>* prog, const vector<char*>& in) {
  for (size_t i = 0; i < in.size(); ++i) {
    switch(in[i][0]) {
      case 's': {
        size_t x;
        sscanf(in[i], "s%zu", &x);
        Spin(prog, x);
        break;
      }
      case 'x': {
        size_t a, b;
        sscanf(in[i], "x%zu/%zu", &a, &b);
        Exchange(prog, a, b);
        break;
      }
      case 'p': {
        char a, b;
        sscanf(in[i], "p%c/%c", &a, &b);
        Partner(prog, a, b);
        break;
      }
    }
  }
}

int main() {
  vector<char> prog;
  for (char i = 0; i < 16; ++i) {
    prog.push_back('a' + i);
  }

  vector<char*> in;
  while (true) {
    char* move = new char[7];
    if (scanf("%[^,\n]", move) == EOF) {
      delete[] move;
      break;
    }
    getchar();
    in.push_back(move);
  }

  vector<char> original(prog);
  int repeat_len = 0;
  for (int i = 0; i < 1000000000; ++i) {
    string tmp(prog.begin(), prog.end());
    string tmp2(original.begin(), original.end());
    if (i == 1) {
      printf("%s\n", tmp.c_str());
    }
    if (i != 0 && tmp == tmp2) {
      repeat_len = i;
      break;
    }
    Move(&prog, in);
  }

  for (int i = 1000000000 % repeat_len; i > 0; --i) {
    Move(&prog, in);
  }

  for (size_t i = 0; i < prog.size(); ++i) {
    printf("%c", prog[i]);
  }
  printf("\n");

  for (size_t i = 0; i < in.size(); ++i) {
    delete[] in[i];
  }

  return 0;
}
