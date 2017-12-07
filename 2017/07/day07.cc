#include <cstdio>
#include <cstring>
#include <map>
#include <string>
#include <vector>

using namespace std;

static int Weight(const map< string, vector<string> >& edges,
                  const map<string, int>& weights,
                  string src,
                  bool find = false,
                  int diff = 0) {
  map<int, int> sums;
  map<int, string> sums_v;
  auto it_edge = edges.find(src);
  for (size_t i = 0; it_edge != edges.end() && i < it_edge->second.size(); ++i) {
    int j = Weight(edges, weights, it_edge->second[i]);
    sums_v[j] = it_edge->second[i];
    if (sums.find(j) == sums.end()) {
      sums[j] = 0;
    }
    ++sums[j];
  }

  int ret = weights.find(src)->second;
  int u_weight = -1;
  int b_weight = -1;
  for (auto it_sum = sums.cbegin(); it_sum != sums.cend(); ++it_sum) {
    ret += it_sum->first * it_sum->second;
    if (it_sum->second == 1 && sums.size() > 1) {
      u_weight = it_sum->first;
    } else {
      b_weight = it_sum->first;
    }
  }

  if (find) {
    if (u_weight == -1) {
      printf("%d\n", weights.find(src)->second + diff);
    } else {
      Weight(edges, weights, sums_v[u_weight], true, b_weight - u_weight);
    }
  }

  return ret;
}

int main() {
  map< string, vector<string> > edges;
  map<string, int> weights;

  map<string, bool> mark;
  while (true) {
    char lhs[16];
    if (scanf("%s", lhs) == EOF) {
      break;
    }
    if (mark.find(lhs) == mark.end()) {
      mark[lhs] = true;
    }

    int w;
    char ch;
    scanf(" (%d)%c", &w, &ch);
    weights[lhs] = w;

    if (ch == ' ') {
      char buf[256];
      scanf("%[^\n]", buf);
      char* rhs = strtok(buf, " ,->");
      while (rhs != nullptr) {
        edges[lhs].push_back(rhs);
        mark[rhs] = false;
        rhs = strtok(nullptr, " ,->");
      }
    }
  }

  for (auto it = mark.cbegin(); it != mark.cend(); ++it) {
    if (it->second) {
#if !defined(PART) || PART == 1
      printf("%s\n", it->first.c_str());
#else
      Weight(edges, weights, it->first, true);
#endif
    }
  }

  return 0;
}
