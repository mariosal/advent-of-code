#include <cstdio>
#include <map>
#include <vector>

using namespace std;

static vector< vector<bool> > R(const vector< vector<bool> >& v) {
  vector< vector<bool> > ret(v.size(), vector<bool>(v.size()));
  for (size_t i = 0; i < ret.size(); ++i) {
    for (size_t j = 0; j < ret[i].size(); ++j) {
      ret[i][j] = v[j][ret[i].size() - i - 1];
    }
  }
  return ret;
}

static vector< vector<bool> > T(const vector< vector<bool> >& v) {
  vector< vector<bool> > ret(v.size(), vector<bool>(v.size()));
  for (size_t i = 0; i < ret.size(); ++i) {
    for (size_t j = 0; j < ret[i].size(); ++j) {
      ret[i][j] = v[j][i];
    }
  }
  return ret;
}

static vector< vector<bool> > Deserialize(const char* s) {
  size_t size = 1;
  for (size_t i = 0; s[i] != '\0'; ++i) {
    if (s[i] == '/') {
      ++size;
    }
  }

  vector< vector<bool> > ret(size, vector<bool>(size));
  size_t j = 0;
  size_t k = 0;
  for (size_t i = 0; s[i] != '\0'; ++i) {
    if (s[i] == '/') {
      ++j;
      k = 0;
    } else {
      ret[j][k] = s[i] == '#';
      ++k;
    }
  }
  return ret;
}

static vector< vector<bool> > Next(
    const vector< vector<bool> >& v,
    const map< vector< vector<bool> >, vector< vector<bool> > >& rules) {
  size_t sub_size;
  if (v.size() % 2 == 0) {
    sub_size = 2;
  } else {
    sub_size = 3;
  }

  size_t ret_size = v.size() / sub_size * (sub_size + 1);
  vector< vector<bool> > ret(ret_size, vector<bool>(ret_size));
  size_t ret_i = 0;
  size_t ret_j = 0;
  vector< vector<bool> > sub(sub_size, vector<bool>(sub_size));
  vector< vector<bool> > tmp(sub_size + 1, vector<bool>(sub_size + 1));
  for (size_t v_i = 0; v_i < v.size(); v_i += sub_size) {
    for (size_t v_j = 0; v_j < v[v_i].size(); v_j += sub_size) {
      for (size_t sub_i = 0; sub_i < sub.size(); ++sub_i) {
        for (size_t sub_j = 0; sub_j < sub[sub_i].size(); ++sub_j) {
          sub[sub_i][sub_j] = v[v_i + sub_i][v_j + sub_j];
        }
      }

      tmp = rules.find(sub)->second;
      for (size_t tmp_i = 0; tmp_i < tmp.size(); ++tmp_i) {
        for (size_t tmp_j = 0; tmp_j < tmp[tmp_i].size(); ++tmp_j) {
          ret[ret_i + tmp_i][ret_j + tmp_j] = tmp[tmp_i][tmp_j];
        }
      }
      ret_j += sub_size + 1;
    }
    ret_i += sub_size + 1;
    ret_j = 0;
  }
  return ret;
}

int main() {
  map< vector< vector<bool> >, vector< vector<bool> > > rules;
  while (true) {
    char lhs_s[12], rhs_s[20];
    if (scanf("%s%*s%s", lhs_s, rhs_s) == EOF) {
      break;
    }
    vector< vector<bool> > lhs(Deserialize(lhs_s));
    vector< vector<bool> > rhs(Deserialize(rhs_s));
    rules[lhs] = rhs;
    rules[R(lhs)] = rhs;
    rules[R(R(lhs))] = rhs;
    rules[R(R(R(lhs)))] = rhs;
    rules[T(lhs)] = rhs;
    rules[R(T(lhs))] = rhs;
    rules[R(R(T(lhs)))] = rhs;
    rules[R(R(R(T(lhs))))] = rhs;
  }

  vector< vector<bool> > grid(Deserialize(".#./..#/###"));
  for (int i = 0; i < 18; ++i) {
    grid = Next(grid, rules);
  }

  size_t on = 0;
  for (size_t i = 0; i < grid.size(); ++i) {
    for (size_t j = 0; j < grid[i].size(); ++j) {
      if (grid[i][j]) {
        ++on;
      }
    }
  }
  printf("#on: %zu\n", on);

  return 0;
}
