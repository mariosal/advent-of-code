#include <cstdio>
#include <map>
#include <queue>
#include <set>
#include <vector>

using namespace std;

struct Port {
  int a;
  int b;
};

struct Component {
  int end;
  int sum;
  set<size_t> ports;

  Component() : end(0), sum(0) {
  }
};

static void Walk(const vector<Port>& ports,
                 const map< int, vector<size_t> >& compat) {
  int max_str = 0;
  size_t max_len = 0;
  int max_len_str = 0;

  queue<Component> q;
  q.push({});
  Component cur, next;
  while (!q.empty()) {
    cur = q.front();
    q.pop();

    if (max_str < cur.sum) {
      max_str = cur.sum;
    }

    if (max_len < cur.ports.size()) {
      max_len = cur.ports.size();
      max_len_str = cur.sum;
    }
    if (max_len == cur.ports.size()) {
      if (max_len_str < cur.sum) {
        max_len_str = cur.sum;
      }
    }

    const vector<size_t>& v = compat.find(cur.end)->second;
    for (size_t i = 0; i < v.size(); ++i) {
      if (cur.ports.find(v[i]) == cur.ports.end()) {
        if (cur.end == ports[v[i]].a) {
          next.end = ports[v[i]].b;
        } else {
          next.end = ports[v[i]].a;
        }

        next.sum = cur.sum + ports[v[i]].a + ports[v[i]].b;

        next.ports = cur.ports;
        next.ports.insert(v[i]);

        q.push(next);
      }
    }
  }

  printf("%d %d\n", max_str, max_len_str);
}

int main() {
  vector<Port> ports;
  map< int, vector<size_t> > compat;
  for (size_t i = 0; ; ++i) {
    int a, b;
    if (scanf("%d/%d", &a, &b) == EOF) {
      break;
    }
    ports.push_back({ a, b });
    compat[a].push_back(i);
    compat[b].push_back(i);
  }

  Walk(ports, compat);

  return 0;
}
