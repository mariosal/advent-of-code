#include <climits>
#include <cstdio>
#include <queue>

struct Edge {
  int x;
  int y;
  int d;
};

static bool operator <(const Edge& a, const Edge& b) {
  if (a.d == b.d) {
    if (a.x == b.x) {
      return a.y < b.y;
    }
    return a.x < b.x;
  }
  return a.d > b.d; // Reverse Prioriry Queue
}

static int Dist(int** a, int n, int x, int y, bool** visited) {
  std::priority_queue<Edge> q;
  q.push({ x, y, 0 });
  while (!q.empty()) {
    Edge e = q.top();
    q.pop();

    if (e.x < 0 || n <= e.x || e.y < 0 || n <= e.y || visited[e.x][e.y]) {
      continue;
    }
    visited[e.x][e.y] = true;

    if (a[e.x][e.y] == 1) {
      return e.d;
    }

    int dx[4] = {0, 1, 0, -1};
    int dy[4] = {-1, 0, 1, 0};
    for (int i = 0; i < 4; ++i) {
      q.push({ e.x + dx[i], e.y + dy[i], e.d + 1 });
    }
  }
  return INT_MAX;
}

static void Fill(int** a, int n) {
  int v = n * n;
  for (int i = 0; i <= n / 2; ++i) {
    for (int j = i; j + i < n; ++j) {
      a[n - 1 - i][n - 1 - j]  = v--;
    }
    for (int j = i + 1; j + i < n; ++j) {
      a[n - 1 - j][i]  = v--;
    }
    for (int j = i + 1; j + i < n; ++j) {
      a[i][j]  = v--;
    }
    for (int j = i + 1; j + i < n - 1; ++j) {
      a[j][n - 1 - i]  = v--;
    }
  }
}

static void Locate(int** a, int n, int v, int* x, int* y) {
  *x = -1;
  *y = -1;
  for (int i = 0; i < n; ++i) {
    for (int j = 0; j < n; ++j) {
      if (a[i][j] == v) {
        *x = i;
        *y = j;
      }
    }
  }
}

int main() {
  const int n = 602;
  int** a = new int*[n];
  bool** visited = new bool*[n];
  for (int i = 0; i < n; ++i) {
    a[i] = new int[n];
    visited[i] = new bool[n]();
  }

  Fill(a, n);

  int x, y;
  Locate(a, n, 361527, &x, &y);

  if (0 <= x && x < n && 0 <= y && y < n) {
    printf("%d\n", Dist(a, n, x, y, visited));
  }

  for (int i = 0; i < n; ++i) {
    delete[] a[i];
    delete[] visited[i];
  }
  delete[] a;
  delete[] visited;

  return 0;
}
