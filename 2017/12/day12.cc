#include <cstdio>
#include <map>
#include <set>
#include <vector>

using namespace std;

static int Dfs(const map< int, vector<int> >& e, int src,
               set<int>* not_visited) {
  if (not_visited->erase(src) == 0) {
    return 0;
  }

  int ret = 1;
  auto neigh = e.find(src)->second;
  for (size_t i = 0; i < neigh.size(); ++i) {
    ret += Dfs(e, neigh[i], not_visited);
  }
  return ret;
}

int main() {
  map< int, vector<int> > e;

  while (true) {
    int u;
    if (scanf("%d%*s", &u) == EOF) {
      break;
    }

    char buf[256];
    scanf("%[^\n]", buf);
    char* p = strtok(buf, ", ");
    while (p != nullptr) {
      int v;
      sscanf(p, "%d", &v);

      e[u].push_back(v);
      e[v].push_back(u);

      p = strtok(nullptr, ", ");
    }
  }

  set<int> not_visited;
  for (auto it = e.cbegin(); it != e.cend(); ++it) {
    not_visited.insert(it->first);
  }

#if !defined(PART) || PART == 1
  printf("%d\n", Dfs(e, 0, &not_visited));
#else
  int groups = 0;
  while (!not_visited.empty()) {
    ++groups;
    Dfs(e, *not_visited.cbegin(), &not_visited);
  }
  printf("%d\n", groups);
#endif

  return 0;
}
