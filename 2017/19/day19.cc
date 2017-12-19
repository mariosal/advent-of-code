#include <cstdio>
#include <string>
#include <vector>

using namespace std;

enum Dir {
  kTop,
  kRight,
  kBottom,
  kLeft
};

struct Point {
  int x;
  int y;
};

static void Path(const vector< vector<char> >& diagram, Point src, Dir dir,
                 string* s, int* len) {
  if (src.y < 0 || diagram.size() <= src.y ||
      src.x < 0 || diagram[src.y].size() <= src.x ||
      diagram[src.y][src.x] == ' ') {
    return;
  }
  ++*len;

  int dx[4] = {  0, 1, 0, -1 };
  int dy[4] = { -1, 0, 1,  0 };
  if (diagram[src.y][src.x] == '+') {
    for (int i = 0; i < 4; ++i) {
      if ((i != (dir + 2) % 4) &&
          diagram[src.y + dy[i]][src.x + dx[i]] != ' ') {
        dir = static_cast<Dir>(i);
        break;
      }
    }
  } else if ('A' <= diagram[src.y][src.x] && diagram[src.y][src.x] <= 'Z') {
    (*s) += diagram[src.y][src.x];
  }

  Point next = { src.x + dx[dir], src.y + dy[dir] };
  Path(diagram, next, dir, s, len);
}

int main() {
  vector< vector<char> > diagram;
  while (true) {
    bool eof = false;
    vector<char> row;
    while (true) {
      char c;
      if (scanf("%c", &c) == EOF) {
        eof = true;
        break;
      }
      if (c == '\n') {
        break;
      }

      row.push_back(c);
    }
    if (eof) {
      break;
    }

    diagram.push_back(row);
  }

  Point src;
  for (size_t i = 0; i < diagram[0].size(); ++i) {
    if (diagram[0][i] == '|') {
      src.y = 0;
      src.x = i;
    }
  }

  string s = "";
  int len = 0;
  Path(diagram, src, kBottom, &s, &len);
  printf("%s %d\n", s.c_str(), len);

  return 0;
}
