#include <cstdio>

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

static int SumAdj(int** b, int n, int x, int y) {
  int sum = 0;
  int dx[8] = { 0,  1, 1, 1, 0, -1, -1, -1};
  int dy[8] = {-1, -1, 0, 1, 1,  1,  0, -1};
  for (int i = 0; i < 8; ++i) {
    if (x + dx[i] < 0 || n <= x + dx[i] || y + dy[i] < 0 || n <= y + dy[i]) {
      continue;
    }
    sum += b[x + dx[i]][y + dy[i]];
  }
  return sum == 0 ? 1 : sum;
}

static void FillSum(int** b, int n, int** a) {
  int x, y;
  Locate(a, n, 1, &x, &y);

  while (true) {
    b[x][y] = SumAdj(b, n, x, y);
    if (b[x][y] > 361527) {
      printf("%d\n", b[x][y]);
      break;
    }
    if (a[x][y] == n * n) {
      break;
    }

    int dx[4] = {0, 1, 0, -1};
    int dy[4] = {-1, 0, 1, 0};
    for (int i = 0; i < 4; ++i) {
      if (x + dx[i] < 0 || n <= x + dx[i] || y + dy[i] < 0 || n <= y + dy[i]) {
        continue;
      }
      if (a[x + dx[i]][y + dy[i]] - a[x][y] == 1) {
        x = x + dx[i];
        y = y + dy[i];
        break;
      }
    }
  }
}

int main() {
  const int n = 602;
  int** a = new int*[n];
  int** b = new int*[n];
  for (int i = 0; i < n; ++i) {
    a[i] = new int[n];
    b[i] = new int[n]();
  }

  Fill(a, n);
  FillSum(b, n, a);

  for (int i = 0; i < n; ++i) {
    delete[] a[i];
    delete[] b[i];
  }
  delete[] a;
  delete[] b;

  return 0;
}
